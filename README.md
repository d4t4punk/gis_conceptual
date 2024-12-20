<p align="center"><img src="https://github.com/user-attachments/assets/4433e014-e0bb-4501-b5a0-b91faff78870" alt="GIS Lakehouse" height="300" width="300"/></p>

Welcome to **GIS Lakehouse**
The GIS Lakehouse repo is a variation of the Steampunk Data Lakehouse architecture with a Geospatial context.  The database code is native postgresql, and the lambda functions are python but written for AWS.

# Getting Started

## Review the diagram
<p align="center"><img src="https://lucid.app/publicSegments/view/23d4d6ac-97e9-49f7-9346-5a163c502d68/image.png" height="300" width="400"/></p>

# Database
## ref_climate schema
The ref_climate schema stores the precipitation and temperature raster data.  Traditionally you'd use raster2pgsql executable, but that doesn't translate well to the cloud where you'd have to host an run the executable.  This solution side-steps the executable route with a 'texas two-step' process by uploading the raw raster as bytea and then letting postgres convert to 50x50 raster data type via database trigger.  As part of the database the executables are required: postgis and postgis_raster which are freely available.

## star_schema schema
The star_schema is meant to pre-calculate geospatial relationships instead of making those determinations at request time.  
As of 2024.12.20 this functionality is currently under development.

# Lambda Functions

## lf-gis-blob-to-raster-trigger

## lf-gis-daily-precip-temp-raster-load
