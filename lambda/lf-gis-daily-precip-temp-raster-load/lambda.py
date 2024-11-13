import os
import boto3
import requests
from datetime import date, timedelta, datetime
import configparser

config = configparser.ConfigParser()
config.read('config.ini')
# Initialize S3 client
s3 = boto3.client('s3')
#db connection info:

# Define the publicly accessible GCS URL
GCS_BASE_URL = "https://storage.googleapis.com/noaa-ncei-nclimgrid-daily/cog/2024/"
S3_BUCKET = "landing-zone-stmpnk"
S3_PREFIX = "gis-raw-raster/"
# Get the last raster date 
def get_max_rstr_date():
    # Get the file
    response = s3.get_object(Bucket='landing-zone-stmpnk', Key='gis-raw-raster/max_raster_dt.txt')
    # read the response
    file_content = response['Body'].read().decode('utf-8')
    return file_content

def lambda_handler(event, context):
    """Lambda function to pull TIFF from GCS and upload to S3"""
    
    start_date = datetime.strptime(get_max_rstr_date(), "%Y-%m-%d").date() + timedelta(days=1)
    print(start_date)
    end_date = date.today()
    filenm = None
    current_date = start_date
    while current_date <= end_date:
        tiff_file = "nclimgrid-daily-" + current_date.strftime("%Y%m%d") + ".tif"
        print(tiff_file)
        
    # for tiff_file in tiff_files:
        # Construct the full URL for the TIFF file on GCS
        gcs_url = GCS_BASE_URL + tiff_file

        print(f"Downloading {tiff_file} from GCS")
        
        # Download the TIFF file
        response = requests.get(gcs_url)
        if response.status_code == 200:
            # Define the target S3 key
            s3_key = S3_PREFIX + tiff_file
            
            # Upload the file to S3
            s3.put_object(Bucket=S3_BUCKET, Key=s3_key, Body=response.content)
            print(f"Uploaded {tiff_file} to S3 at {s3_key}")
        else:
            print(f"Failed to download {tiff_file} from GCS. Status code: {response.status_code}")
        
        current_date += timedelta(days=1)
    return {
        'statusCode': 200,
        'body': f'Successfully uploaded TIFF files to {S3_BUCKET}/{S3_PREFIX}'
    }
