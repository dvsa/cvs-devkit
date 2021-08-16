#!/bin/bash


Help()
{
   # Display Help
   echo "======================================================================="
   echo "=       This is a tool to download certificates from localstack       ="
   echo "======================================================================="
   echo "options:"
   echo "-k     pass localstack url in the form of s3://bucket/key"
   echo
}

Download()
{
    echo "Downloading key: $1 ................"
    aws s3 cp $1 certificates/ --region eu-west-1 --endpoint=http://localhost:4566
}

while getopts ":hk" option; do
   case ${option} in
      h) # display Help
         Help
         exit;;
      k) # run mac script
         if [ $# -eq 1 ]
            then
              echo "No arguments supplied. Please specify the key path in the form of s3://bucket/object"
         else
            key="$2"
            Download "$key"
         fi
         exit;;
      \?)
         echo "Error: Invalid option"
   esac
done
Help
