#!/bin/bash
# build and pack a swift library

set -eo pipefail

CONFIGURATION=${CONFIGURATION:-release}
BUILD_FOLDER=${BUILD_FOLDER:-.build-serverless}
ARTIFACT_FOLDER=${ARTIFACT_FOLDER:-.serverless-swift}
ARTIFACT_LAMBDA_FOLDER=${ARTIFACT_LAMBDA_FOLDER:-lambda}


echo "Build: Started \"swift build --configuration ${CONFIGURATION}\""

rm -rf ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/
mkdir -p ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}

# Need to fix Host key verification failure for github.com 
#
# https://stackoverflow.com/a/27488865
if [ -z "$SSH_AUTH_SOCK" ]
then 
  echo ""
else
  mkdir -p ~/.ssh/
  ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
fi

swift build --configuration ${CONFIGURATION} --build-path ${BUILD_FOLDER}

echo "Build: Finished \"swift build\""
echo "Build: Started packaging the build"

find ${BUILD_FOLDER}/${CONFIGURATION}/ -type f -executable -exec cp {} ${PWD}/${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/ \;
find ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/ -type f -executable -exec zip -qj '{}'.zip '{}' \;
find ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/ -type f -executable -exec rm '{}' \;

echo "Build: Finished packing the build"

echo "Build: All done"
