#!/bin/bash


SERVICES=(
  'cvs-svc-authoriser'
  'cvs-svc-activities'
  'cvs-svc-defects'
  'cvs-svc-app-logs'
  'cvs-svc-preparers'
  'cvs-svc-test-stations'
  'cvs-svc-test-types'
  'cvs-svc-test-number'
  'cvs-svc-test-results'
)

Help()
{
   # Display Help
   echo "========================================"
   echo "=       This is the s3 bootstrap       ="
   echo "========================================"
   echo "options:"
   echo "-b     Generate buckets and upload"
   echo "-u     Update zip files"
   echo
}
Bootstrap()
{
  AWS_PAGER= aws s3api create-bucket --bucket 'cvs-services' --region eu-west-1 --endpoint=http://localhost:4566
}

Upload()
{
  for service in "${SERVICES[@]}"; do
    LOCAL_SHA=(`openssl dgst -sha256 -binary ../$service/localstack.zip | openssl enc -base64`)
    REMOTE_SHA=(`AWS_PAGER= aws s3api head-object --bucket 'cvs-services' --key $service/latest.zip --region eu-west-1 --endpoint=http://localhost:4566 --query Metadata.sha --output text 2> /dev/null`)
    if [[ "$LOCAL_SHA" == "$REMOTE_SHA" ]]; then
        echo "Service zip file for $service is already deployed to its latest version"
    else
        aws s3 cp ../$service/localstack.zip s3://cvs-services/$service/latest.zip --metadata "sha=$LOCAL_SHA" --region eu-west-1 --endpoint=http://localhost:4566
    fi
  done
}

while getopts ":hbu" option; do
   case ${option} in
      h) # display Help
         Help
         exit;;
      b) # run windows script
         Bootstrap
         Upload
         exit;;
      u) # run mac script
         Upload
         exit;;
      \?)
         echo "Error: Invalid option"
   esac
done
Help
