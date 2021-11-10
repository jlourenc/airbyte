#! /bin/bash

set -ex

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

rm -rf /tmp/old-docker-compose
mkdir /tmp/old-docker-compose

NEW_HASH="$( git rev-parse HEAD )"

git checkout master
git pull --no-rebase

# TODO: Change to docker-image build when merge
SUB_BUILD=PLATFORM "$SCRIPT_DIR"/../../gradlew -p "$SCRIPT_DIR"/../.. assemble

curl https://raw.githubusercontent.com/airbytehq/airbyte/master/docker-compose.yaml > /tmp/old-docker-compose/docker-compose.yaml

docker-compose -f /tmp/old-docker-compose/docker-compose.debug.yaml up &

sleep 2m

git checkout $NEW_HASH
SUB_BUILD=PLATFORM "$SCRIPT_DIR"/../../gradlew -p "$SCRIPT_DIR"/../.. assemble

docker-compose -f "$SCRIPT_DIR"/../../docker-compose.yaml up
