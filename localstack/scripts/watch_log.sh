#!/bin/bash


Banner()
{
   echo "======================================================================="
   echo "=              This is a tool to watch logs in realtime               ="
   echo "======================================================================="
   echo "options:"
   echo "-k     pass log group name"
   echo
}

Watch()
{
    echo "Opening cloudwatch log group for : $1 ................"
    awslogs get /aws/lambda/cvs-localstack-$1  ALL --watch  --aws-region eu-west-1 --aws-endpoint-url=http://localhost:4566
}

while getopts ":k" option; do
   case ${option} in
      k)
         if [ $# -eq 1 ]
            then
              echo "No arguments supplied. Please specify the cloudwatch log group"
         else
            key="$2"
            Watch "$key"
         fi
         exit;;
      \?)
         echo "Error: Invalid option"
   esac
done
Banner
