# CVS Localstack


## Localstack Setup
The following steps have been tested on macOS Catalina 10.15.7 only

#### Hardware Prerequisites
* 10GB of RAM
* 6 CPUs

#### Prerequisites
1. Make sure the latest docker engine is installed and up to date. [Download the latest version here](https://www.docker.com/products/docker-desktop)
2. Make sure you have brew installed. [Download the latest version here](https://brew.sh/)
3. Make sure terraform 13 or higher  [Download the latest version here](https://learn.hashicorp.com/tutorials/terraform/install-cli)
4. Make sure you have the awscli v2 installed [Download the latest version here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html)
5. Make sure you have awslogs installed [Download the latest version here](https://github.com/jorgebastida/awslogs)
6. Open docker preferences and under resources, file sharing make sure you have `/private` in the resources list.
7. This version of localstack requires an API key. You will need to create a subscription on https://app.localstack.cloud/  to be able to test use these script. The subscription needs to be exported prior to running the docker-compose up script. `export LOCAL_API_KEY=xxxxxxxxx`

#### Create Localstack virtual environment for the impatient
0. The recommendation is to close as many applications as possible as this process requires quite a bit of computational power
1. Open a new terminal window and navigate into the `scripts` directory
2. Export the localstack PRO api key by running `export LOCALSTACK_API_KEY=xxxxxxxxx`
3. Run the following command `docker-compose up` and wait until the container is up and running

<a href="https://asciinema.org/a/BiiNAnwOzmVtX2JN8N8hi3f2Z?t=2" target="_blank"><img src="https://asciinema.org/a/BiiNAnwOzmVtX2JN8N8hi3f2Z.svg" width="750" /></a>

4. In a different terminal navigate into the scrip folder and run the `./prepare_localstack.sh` script

<a href="https://asciinema.org/a/UvjpRkP25hk5skGWdg4dCxRFj?t=2" target="_blank"><img src="https://asciinema.org/a/UvjpRkP25hk5skGWdg4dCxRFj.svg" width="750"/></a>

#### Create Localstack virtual environment for the geeks
0. The recommendation is to close as many applications as possible as this process requires quite a bit of computational power
1. Open a new terminal window and navigate into the `scripts` directory
2. Export the localstack PRO api key by running `export LOCALSTACK_API_KEY=xxxxxxxxx`
3. Run the following command `docker-compose up` and wait until the container is up and running
4. Upload the latest zip files into localstack by running `./upload_all.sh -b` in the same directory. Wait until this process finish
5. Now change directory and go to the terraform folder and run `terraform init`
6. If the step was successful run `terraform apply` and confirm the creation of the localstack infrastructure.
7. Once the script finish you can go back into the scripts folder and run `npm install` in the seed folder. Go up a folder and seed all services by running `./seed_all.sh`
8. Upload a sample signature document into the signature bucket by running the `./upload-signature.sh`
9. You can now import the postman collection from the postman folder which will provide all necessary scripts required to run the services.
10. Using the test results payloads you can generate a certificate. The certificate will be generated in the cvs-cert-localstack bucket
11. Use the download-certificate.sh script to download the pdf file from the bucket. The s3 key required can be found under https://app.localstack.cloud/resources/s3 in the `cvs-cert-localstack/localstack` bucket folder

## Dashboard
It is possible to navigate localstack portal by browsing the following url. You will need a subscription to be able to do so https://app.localstack.cloud/dashboard


## License
This tool kit is available as open source under the terms of the [MIT](https://opensource.org/licenses/MIT).