#!/bin/bash
# build and pack a swift library

set -eo pipefail

CONFIGURATION=${CONFIGURATION:-release}
BUILD_FOLDER=${BUILD_FOLDER:-.build-serverless}
ARTIFACT_FOLDER=${ARTIFACT_FOLDER:-.serverless-swift}

ARTIFACT_LAMBDA_FOLDER=${ARTIFACT_LAMBDA_FOLDER:-lambda}
ARTIFACT_LAYER_FOLDER=${ARTIFACT_LAYER_FOLDER:-layer}

rm -rf ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/
rm -rf ${ARTIFACT_FOLDER}/${ARTIFACT_LAYER_FOLDER}/

mkdir -p ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}
mkdir -p ${ARTIFACT_FOLDER}/${ARTIFACT_LAYER_FOLDER}

swift build --configuration ${CONFIGURATION} --build-path ${BUILD_FOLDER}

find ${BUILD_FOLDER}/${CONFIGURATION}/ -type f -executable -exec cp {} ${PWD}/${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/ \;
find ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/ -type f -executable -exec zip -j '{}'.zip '{}' \;
find ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/ -type f -executable -exec rm '{}' \;


