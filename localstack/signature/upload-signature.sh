#!/bin/bash

Help()
{
   # Display Help
   echo "======================================================"
   echo "=       This is the s3 signature upload script       ="
   echo "======================================================"
   echo "options:"
   echo "-h     Display help"
   echo "-u     Upload base64 files"
   echo
}

Upload()
{
  aws s3 cp 5c4ed163-e54b-400f-ab9a-9d75c658c131.base64 s3://cvs-signature-localstack/localstack/5c4ed163-e54b-400f-ab9a-9d75c658c131.base64 --region eu-west-1 --endpoint=http://localhost:4566
}

while getopts ":hu" option; do
   case ${option} in
      h) # display Help
         Help
         exit;;
      u) # run mac script
         Upload
         exit;;
      \?)
         echo "Error: Invalid option"
   esac
done
Help
