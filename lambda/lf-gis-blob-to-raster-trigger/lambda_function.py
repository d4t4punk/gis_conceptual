import json
import psycopg2
import boto3
import configparser
import os

config = configparser.ConfigParser()
config.read('config.ini')

# Initialize the S3 client
s3 = boto3.client('s3')

# Database connection details
db_host = config['database']['host']
db_pass = config['database']['password']
db_schema = config['database']['schema']
db_port = config['database']['port']
db_user = config['database']['user']
db_name = config['database']['db']
env = config['environment']['env']

# write file to track the latest raster date in the system
def write_file_to_qt_zne(file_nm, file_content):
    print('quarantine')
    try:
        print(file_nm)
        s3.put_object(
            Bucket="quarantine-zone-stmpnk",
            Key=f"raw_gis_rasters_error/{file_nm}",
            Body=file_content
        )
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Error writing quarantine file to S3: {str(e)}"
        }
# write file to track the latest raster date in the system
def write_max_raster_dt(obj_key):
    print('wmrstrdt')
    try:
        dt_str = obj_key[-12:][:8][:4] + "-" + obj_key[-12:][:8][4:][:2] + "-" + obj_key[-12:][:8][4:][2:]
        print(dt_str)
        s3.put_object(
            Bucket='landing-zone-stmpnk',
            Key='gis-raw-raster/max_raster_dt.txt',
            Body=dt_str
        )
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Error writing max_raster_dt file to S3: {str(e)}"
        }
def dq_check_num_rasters(file_content):
    Connection = None
    iret = None
    try:

        # Connect to PostgreSQL
        connection = psycopg2.connect(
            host=db_host,
            database=db_name,
            user=db_user,
            password=db_pass,
            port=db_port
        )
        
        cursor = connection.cursor()
        
        # SQL query to insert the file (as BYTEA) into the table
        insert_query = """
            SELECT ref_climate.fnct_dq_raster_num_bands(%s)
        """
        print("b4 exe")
        # Execute the query
        cursor.execute(insert_query, (psycopg2.Binary(file_content),))
        # cursor.callproc('ref_climate.fnct_dq_raster_num_bands',[psycopg2.Binary(file_content),])
        # iret = cursor.fetchone()
        iret = cursor.fetchone()[0]
        print(iret)
    except Exception as error:
        print(f"Error inserting file {object_key} into PostgreSQL: {error}")
        raise

    finally:
        # Close the database connection
        if connection:
            cursor.close()
            connection.close()
        return iret

def store_file_in_postgres(object_key, file_content):
    Connection = None
    try:
        print(db_host)
        # Connect to PostgreSQL
        connection = psycopg2.connect(
            host=db_host,
            database=db_name,
            user=db_user,
            password=db_pass,
            port=db_port
        )
        
        cursor = connection.cursor()
        
        # SQL query to insert the file (as BYTEA) into the table
        insert_query = """
            INSERT INTO ref_climate.geotiff_blobs (blob_data, file_name)
            VALUES (%s, %s)
        """
        print("b4 cur exec")
        # Execute the query
        cursor.execute(insert_query, (psycopg2.Binary(file_content), object_key))

        # Commit the transaction
        connection.commit()
        # write the max raster dt to track
        write_max_raster_dt(object_key)

        print(f"File {object_key} inserted into PostgreSQL successfully.")

    except Exception as error:
        print(f"Error inserting file {object_key} into PostgreSQL: {error}")
        raise

    finally:
        # Close the database connection
        if connection:
            cursor.close()
            connection.close()
def lambda_handler(event, context):
    
   for record in event['Records']:
        # Get the bucket name and object key from the event
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        print(db_host)
        print(object_key)
        # Get the file
        print('b4 resp')
        response = s3.get_object(Bucket=bucket_name, Key=object_key)
        # read the response
        file_content = response['Body'].read()
        # check the number of rasters
        inumrast = dq_check_num_rasters(file_content)
        # do we have the correct number of rasters?
        if inumrast == 4:
            # store file in postgresql
            store_file_in_postgres(object_key, file_content)
        else:
            # lmbda_cli = boto3.client("lambda")
            sns = boto3.client("sns")
            # move raster to quarantine
            filenm = object_key.split("/")[-1]
            write_file_to_qt_zne(filenm, file_content)
            # send sns alert
            # fnct_arn = "arn:aws:lambda:us-east-1:571600842530:function:lf-common-sns"
            msg = "A GIS LH raster, " + filenm + " did not have the correct number of bands and has been copied to the quarantine zone."
            # print(msg)
            # ?ata = {"sns_arn": "arn:aws:sns:us-east-1:571600842530:gis-lh-dq", "message": msg, "subject": "GIS LH - Bad Raster Encountered"}
            
            # response = lmbda_cli.invoke(FunctionName=fnct_arn, InvocationType='RequestResponse', Payload=json.dumps(data))
            response = sns.publish(TopicArn='arn:aws:sns:us-east-1:571600842530:gis-lh-dq', Message=msg, Subject='GIS Lakehouse - Bad Raster')


