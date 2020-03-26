#!/bin/bash

set -e

: ${GCLOUD_REGISTRY:=gcr.io}
: ${IMAGE:=$GITHUB_REPOSITORY}
: ${ARGS:=} # Default: empty build args
: ${TAG:=$GITHUB_SHA}
: ${BRANCH:=''}
: ${LATEST:=true}
: ${WORKING_DIRECTORY:=.}

docker build $ARGS -t $IMAGE:$TAG $WORKING_DIRECTORY
docker tag $IMAGE:$tag $GCLOUD_REGISTRY/$IMAGE:$TAG # SHA or custom tag

if [ $LATEST = true ]; then
  docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:latests # Latest tag
fi

if [ -n "$BRANCH" ]; then
  docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:$BRANCH # Branch tag
fi
