#!/bin/bash

Help()
{
   echo "======================================================"
   echo "=       This is the localstack bootstrap             ="
   echo "======================================================"
   echo "options:"
   echo "-c     check all dependencies                         "
   echo "-b     bootstrap localstack                           "
   echo
}

Check()
{
  response=(`curl --write-out "%{http_code}\n" --silent --output /dev/null "http://localhost:4566/health"`)

  if [ ${response} -eq 200 ]; then
     echo "Localstack is up."
  else
     echo "Localstack is down."
     exit 1
  fi
  if ! command -v jq --version &> /dev/null
  then
    echo "jq could not be found"
    exit
  else
    JQ_VERSION=(`jq --version`)
    echo "jq is installed. version: $JQ_VERSION"
  fi
  if ! command -v terraform --version &> /dev/null
  then
    echo "jq could not be found"
    exit
  else
    TERRAFORM_VERSION=(`terraform version -json | jq -r '.terraform_version'`)
    echo "terraform is installed. version: $TERRAFORM_VERSION"
  fi

  if ! command -v npm --version &> /dev/null
    then
      echo "node could not be found"
      exit
  else
    NODE_VERSION=(`npm --version`)
    echo "node is installed. version: $NODE_VERSION"
  fi
  if ! command -v awslogs --version &> /dev/null
    then
      echo "awslogs could not be found"
      exit
  else
    AWSLOGS_VERSION=(`awslogs --version`)
    echo "awslogs is installed. version: $AWSLOGS_VERSION"
  fi
  if ! command -v aws --version &> /dev/null
  then
      echo "aws could not be found"
      exit
  else
    AWS_VERSION=(`aws --version`)
    echo "aws is installed. version: $AWS_VERSION"
  fi
}

Bootstrap()
{
  echo "Setting zip files"
  ./upload_all.sh -b
  cd ../terraform
  terraform init
  terraform apply -auto-approve
  cd ../scripts
  ./upload_reference_data.sh
  cd seed
  npm install
  cd ..
  ./seed_all.sh
  ./upload_signature.sh
  ./get_api_id.sh
}

while getopts ":hcb" option; do
   case ${option} in
      h) Help
         exit;;
      c) Check
         exit;;
      b) Check
         Bootstrap
         exit;;
      \?)
         echo "Error: Invalid option"
   esac
done
Help
