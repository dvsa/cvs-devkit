#!/bin/bash

Help()
{
   # Display Help
   echo "===================================================="
   echo "=       This is the script to get the api id       ="
   echo "===================================================="
}

RetrieveId()
{
  AWS_API_ID=(`AWS_PAGER= aws apigateway get-rest-apis --region eu-west-1 --endpoint=http://localhost:4566 --query 'items[].id' --output text`)
  echo "ID is: $AWS_API_ID"
  echo "API is: http://localhost:4566/restapis/$AWS_API_ID/localstack/_user_request_/"

  echo "EXAMPLE API is: http://localhost:4566/restapis/$AWS_API_ID/localstack/_user_request_/defects"
}

Help
RetrieveId