## About

This repo will allow you to deploy [Evobot](https://github.com/eritislami/evobot) to your Discord server, hosted on a Google Cloud Platform Virtual Machine.

## Requirements

[Docker](https://docs.docker.com/engine/install/)

[Google Cloud Platform](https://console.cloud.google.com) account

## Setup for Windows (Only tested on Windows 10)

1. Authenticate with [gcloud](https://cloud.google.com/sdk/docs/install) locally. These credentials will be mounted via docker-compose.yml
  - `gcloud auth login`

2. Create your Google Cloud Project
  - `gcloud projects create PROJECT_ID`. Replace PROJECT_ID by setting a unique project ID. It will take a few minutes for this project to appear in your [GCP Console](https://console.cloud.google.com)

3. [Set billing account for new project](https://console.cloud.google.com/billing/projects?organizationId=0&supportedpurview=project,organizationId,folder)

4. [Create discord bot and register a token](https://discordjs.guide/preparations/setting-up-a-bot-application.html#creating-your-bot)

5. In docker-compose.yml, update the variable GCP_PROJECT with your Project ID. 
  - Here you can also set the [GCP Region and Zone](https://cloud.google.com/compute/docs/regions-zones) you want your VM to be created in. By default we are using us-central.
  - While you are in the docker-compose.yml, update the DISCORD_TOKEN to the Token you registered for your Discord Server

6. Run `docker-compose build` to build the image

7. Run `docker-compose up` to start the container and your Bot user should shortly join your Discord server.

## Information

See [evobot documentation](https://github.com/eritislami/evobot?tab=readme-ov-file#-features--commands) for commands.

If you want to tear it all down, change the "apply" in docker-compose.yml to "destroy".
