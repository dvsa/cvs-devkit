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

    curl https://github.com/dvsa/cvs-svc-$service/blob/develop/tests/resources/$service.json > ./reference-data/$service
  done
}

Help
Update
