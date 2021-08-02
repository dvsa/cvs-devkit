#!/bin/bash

Help()
{
   # Display Help
   echo "======================================================"
   echo "=       This is the s3 signature upload script       ="
   echo "======================================================"
}

Upload()
{
  aws s3 cp signature/5c4ed163-e54b-400f-ab9a-9d75c658c131.base64 s3://cvs-signature-localstack/localstack/5c4ed163-e54b-400f-ab9a-9d75c658c131.base64 --region eu-west-1 --endpoint=http://localhost:4566
}

Help
Upload
