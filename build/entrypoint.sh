#!/bin/bash

set -e

: ${GCLOUD_REGISTRY:=gcr.io}
: ${IMAGE:=$GITHUB_REPOSITORY}
: ${ARGS:=} # Default: empty build args
: ${TAG:=$GITHUB_SHA} # Default tag to git SHA
: ${BRANCH_TAG:=true}
: ${LATEST:=true}
: ${WORKING_DIRECTORY:=.} # Default to CWD

docker build $ARGS -t $IMAGE:$TAG $WORKING_DIRECTORY
docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:$TAG # SHA or custom tag

if [ $LATEST = true ]; then
  docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:latest # Latest tag
fi

if [ $BRANCH_TAG = true ]; then
  BRANCH_RAW=$GITHUB_REF
  if [ -n "$GITHUB_HEAD_REF" ]; then
    BRANCH_RAW=$GITHUB_HEAD_REF
  fi
  BRANCH=$(echo $BRANCH_RAW | rev | cut -f 1 -d / | rev)
  docker tag $IMAGE:$TAG $GCLOUD_REGISTRY/$IMAGE:$BRANCH # Branch tag
fi
