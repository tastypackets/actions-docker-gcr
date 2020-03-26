#!/bin/bash

set -e

: ${GCLOUD_REGISTRY:=gcr.io}
: ${IMAGE:=$GITHUB_REPOSITORY}
: ${ARGS:=} # Default: empty build args
: ${TAG:=$GITHUB_SHA}
: ${BRANCH_TAG:=true}
: ${LATEST:=true}
: ${WORKING_DIRECTORY:=.}

echo $GITHUB_SHA
echo $GITHUB_REF
echo $TAG

docker build $ARGS -t $IMAGE:$TAG $WORKING_DIRECTORY
docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:$TAG # SHA or custom tag

if [ $LATEST = true ]; then
  docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:latest # Latest tag
fi

if [ $BRANCH_TAG = true ]; then
  BRANCH=$(echo $GITHUB_REF | rev | cut -f 1 -d / | rev)
  docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:$BRANCH # Branch tag
fi
