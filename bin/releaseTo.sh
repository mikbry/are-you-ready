#!/bin/bash

#  Copyright (C) 2020 Mik BRY                                         
#  mbry@miklabs.com
# LICENCE MIT
# See LICENSE.md

# releaseTo image1 -r github -f Dockerfile -n appName
# image a serie of images
# -r --registry : Mandatory  = github | heroku (TODO : Docker, GCloud, any ...)
# -f --file : The docker file  to build image, if not present will use image directly
# -n -name : repo name | application name used by Heroku 
#
# ENV
#
# Github Action | Git
# github.repository | GIT_REPO
# github.ref | GIT_REF
#
# Github Package
# secrets.GITHUB_TOKEN | GITHUB_TOKEN
#
# Heroku
# HEROKU_API_KEY
#
# If permission denied
# chmod 755 releaseTo.sh
echo "start releaseTo $@"

PARAMS=""
REGISTRY="github"
FILE="Dockerfile"
NAME="AppName"

function help () {
    echo "Publish an image to a Docker registry server"
    echo ""
    echo "Syntax: releaseTo image [-h|r|f|n]"
    echo "options:"
    echo "\t-h --help"
    echo "\-r --registry=$REGISTRY"
    echo "\-f --file=$FILE"
    echo "\n--name=$NAME"
    echo ""
}

REGISTRY=""
FILE=""
NAME=""

# Inspiration : https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
while (( "$#" )); do
  case "$1"  in
    -h | --help)
      help
      exit
      ;;
    -r | --registry)
      if [ -n "$2" ]; then
        REGISTRY=$2
        shift
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -f | --file)
      if [ -n "$2" ]; then
        FILE=$2
        shift
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;       
    -n | --name)
      if [ -n "$2" ]; then
        NAME=$2
        shift
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    -*|--*=)
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) 
      PARAMS="$PARAMS $1"
      ;;      
  esac
  shift
done

if [ -z "$PARAMS" ] && [ -z "$REGISTRY" ]; then
  echo "Error: image and --registry/-r should be provided"
  exit 1
fi

# TODO get first image
IMAGE_NAME="$(echo "${PARAMS}" | tr -d '[:space:]')";

REGISTRY_SERVER=""

## REGISTRY SERVER
if [ "$REGISTRY" == "github" ]; then
  if [ -z "$GIT_REPO" ]; then
    echo "Error: Env GIT_REPO is undefined"
    exit 1
  fi
  if [ -z "$GIT_USERNAME" ]; then
    echo "Error: Env GIT_USERNAME is undefined"
    exit 1
  fi
  if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: Env GITHUB_TOKEN is undefined"
    exit 1
  fi
  NAME="$GIT_REPO"
  REGISTRY_SERVER="docker.pkg.github.com"
  # Log into registry
  echo "$GITHUB_TOKEN" | docker login $REGISTRY_SERVER -u $GIT_USERNAME --password-stdin
elif [ "$REGISTRY" == "heroku" ]; then
  REGISTRY_SERVER="registry.heroku.com"
  if [ -z "$HEROKU_API_KEY" ]; then
    echo "Error: Env HEROKU_API_KEY is undefined"
    exit 1
  fi
  echo "$HEROKU_API_KEY" | docker login $REGISTRY_SERVER --username=_  --password-stdin
else
  echo "Error: Argument for registry is unknown $REGISTRY should be 'github' or 'heroku'"
  exit 1
fi

if [ -z "$GIT_REF" ]; then
  echo "Error: Env GIT_REF is undefined"
  exit 1
fi

if [ -z "$NAME" ]; then
  echo "Error: --name/n should be provided"
  exit 1
fi

IMAGE_ID=$REGISTRY_SERVER/$NAME/$IMAGE_NAME
VERSION=$GIT_REF
VERSION=$(echo "$GIT_REF" | sed -e 's,.*/\(.*\),\1,')
[[ "$GIT_REF" == "refs/tags/"* ]] && VERSION=$(echo $VERSION | sed -e 's/^v//')
[ "$VERSION" == "master" ] && VERSION=latest


echo "releaseTo : image=$IMAGE_NAME imageId=$IMAGE_ID version=$VERSION"

if [ -n "$FILE" ]; then
  docker build --file $FILE . --tag $IMAGE_NAME
fi

docker tag $IMAGE_NAME $IMAGE_ID:$VERSION
docker push $IMAGE_ID:$VERSION

if [ "$REGISTRY" == "heroku" ]; then
  export HEROKU_API_KEY=$HEROKU_API_KEY
  heroku container:login
  heroku container:release web --app $NAME
  heroku ps:scale web=1 --app $NAME
fi

echo "Done $REGISTRY $IMAGE_NAME $NAME"
