#!/usr/bin/env node

const AWS = require('aws-sdk');
const fs = require('fs');
const path = require('path');

const dbClient = new AWS.DynamoDB.DocumentClient({
            region: 'eu-west-1',
            endpoint: 'localhost:4566',
            accessKeyId: 'mock_access_key',
            sslEnabled: false,
            secretAccessKey: 'mock_secret_key'
});
        // Load command line arguments
const tableName = process.argv[2];
console.log(tableName)
const resourceLocation = process.argv[3];

// Loading resource and splitting it into batches
const resource = JSON.parse(fs.readFileSync(path.resolve(__dirname, resourceLocation)));

let batches = [];

while (resource.length > 0)
    batches.push(resource.splice(0, 25));

    // Sending batch write command for each batch
    for (const batch of batches) {
        // Query for DocumentClient
        let query = {
            RequestItems: {}
        };

        // Adding table name to query.
        // The array should contain operations to be done on said table.
        query.RequestItems[tableName] = [];

        for (const item of batch) {
            query.RequestItems[tableName].push({
                PutRequest: {
                    Item: item
                }
            })
        }

        dbClient.batchWrite(query).promise()
            .then((result) => {
                console.info(result);
            })
            .catch((error) => {
                console.error(error)
            });
    }
