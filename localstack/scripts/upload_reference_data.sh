#!/bin/bash


SERVICES=(
  'activities'
  'defects'
  'preparers'
  'test-stations'
  'test-types'
  'test-number'
  'test-results'
  'technical-records'
)

Help()
{
   # Display Help
   echo "==================================================="
   echo "=       This is the reference data updater        ="
   echo "==================================================="
}

Update()
{
  for service in "${SERVICES[@]}"; do
    echo "Downloading reference data for $service"
    curl -s https://raw.githubusercontent.com/dvsa/cvs-svc-$service/develop/tests/resources/$service.json > ./reference-data/$service.json
  done
}

Help
Update
