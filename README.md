# CVS Devkit

#### Run AWS Lambda node functions locally with a mock API Gateway and DynamoDB to test against

- `npm install`
- `node_modules/.bin/sls dynamodb install`
- `npm start` to start serverless locally with default ports
- `IS_OFFLINE=true DYNAMO_PORT={dynamodb port} SERVERLESS_PORT={serverless port} ./node_modules/serverless/bin/serverless offline start` to start serverless locally with custom ports

## Description

This dev tool allows to manage multiple git operations across all CVS Dev Services

## Installation


To get started locally, follow these instructions:

#### Gem Installation

Download and install rake with the following.

```
  gem install rake
```

Please follow the rake documentation on how to install the package on your machine

#### First

1. clone this repository in your project directory
1. cd into the project and run `rake clone`

## Usage


| Command | Description |
| --- | --- |
|rake help|--  display help|
|rake branch|--  display current branch of all repos|
|rake clone|--  run 'git clone' on all repos|
|rake pull|--  run 'git pull --rebase' on all repos|
|rake create_branch "BRANCH"|--  run 'git checkout -b BRANCH' on all repos|
|rake checkout_master |--  run 'git checkout master' on all repos|
|rake checkout_develop |--  run 'git checkout develop' on all repos|
|rake needs_commit|--  checks if any of the repos need a commit|
|rake install|--  run npm install in all repositories|
|rake start|--  run npm run start in all repositories|


## Testing
In order to test, you need to run the following:
- `npm run test` for unit tests
- `npm run test-i` for integration tests
- The `IS_OFFLINE` environment variable needs to be set to `true` in order for the microservice to connect to the local dynamodb instance. Defaults to `true`
- The `SERVERLESS_PORT` environment variable needs to be set to a value representing the port you want the serverless instance to run on. This variable is mandatory. Defaults to `3000`
- The `DYNAMO_PORT` environment variable needs to be set to a value representing the port you want the dynamodb shell to run on. This variable is mandatory. Defaults to `8000`.



## Contributing

Bug reports and pull requests are welcome on GitHub.


## Localstack

#### Prerequisites
0. Clear your env from any previous version of Python that is not your system version
1. Got to https://www.python.org/downloads/release/ and download the latest version of python
2. Proceed with the installation
3. Open terminal and run `python3.9 -V` which should return the newly installed version
4. Upgrade pip by running `python3.9 -m pip install pip --upgrade`
5. Install Pipenv by running `python3.9 -m pip install pipenv`
6. Verify Pipenv `pipenv`
7. Install the following


#### Create Localstack virtual environment
0. Make sure you are running docker locally
1. Navigate into the `./localstack` directory and initialize the environment by running ./init_localstack.sh


## License

This tool kit is available as open source under the terms of the [MIT](https://opensource.org/licenses/MIT).