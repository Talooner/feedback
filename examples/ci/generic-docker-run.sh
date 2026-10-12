#!/bin/sh
set -eu
docker run --rm \
  -e TALOONER_PROVIDER=gitlab \
  -e TALOONER_LICENSE_KEY \
  -e TALOONER_MODEL_BASE_URL -e TALOONER_MODEL -e TALOONER_MODEL_API_KEY \
  -e GITLAB_TOKEN -e GITLAB_API_URL \
  -e CI_PROJECT_ID -e CI_MERGE_REQUEST_IID -e CI_PIPELINE_SOURCE \
  ghcr.io/talooner/talooner-runner:0
