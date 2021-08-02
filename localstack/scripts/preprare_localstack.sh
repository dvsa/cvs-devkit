#!/bin/bash

Banner()
{
   echo "======================================================"
   echo "=       This is the localstack bootstrap             ="
   echo "======================================================"
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
  if ! command -v terraform --version &> /dev/null
  then
    echo "terraform could not be found"
    exit
  fi

  if ! command -v npm --version &> /dev/null
    then
      echo "node could not be found"
      exit
  fi
  if ! command -v awslogs --version &> /dev/null
    then
      echo "awslogs could not be found"
      exit
  fi
  if ! command -v aws --version &> /dev/null
    then
      echo "aws could not be found"
      exit
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

Banner
Check
Bootstrap
