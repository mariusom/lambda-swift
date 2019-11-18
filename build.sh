#!/bin/bash
# build and pack a swift library

set -eo pipefail

CONFIGURATION=${CONFIGURATION:-release}
BUILD_FOLDER=${BUILD_FOLDER:-.build-serverless}
ARTIFACT_FOLDER=${ARTIFACT_FOLDER:-.serverless-swift}

ARTIFACT_LAMBDA_FOLDER=${ARTIFACT_LAMBDA_FOLDER:-lambda}
ARTIFACT_LAYER_FOLDER=${ARTIFACT_LAYER_FOLDER:-layer}


case "$1" in

  build) echo "Build: Started \"swift build --configuration ${CONFIGURATION}\""

    rm -rf ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/
    mkdir -p ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}

    swift build --configuration ${CONFIGURATION} --build-path ${BUILD_FOLDER}

    echo "Build: Finished \"swift build\""
    echo "Build: Started packaging the build"

    find ${BUILD_FOLDER}/${CONFIGURATION}/ -type f -executable -exec cp {} ${PWD}/${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/ \;
    find ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/ -type f -executable -exec zip -qj '{}'.zip '{}' \;
    find ${ARTIFACT_FOLDER}/${ARTIFACT_LAMBDA_FOLDER}/ -type f -executable -exec rm '{}' \;

    echo "Build: Finished packing the build"

    echo "Build: All done"
    ;;

  layer) echo "Layer: Started packing the swift layer"

    rm -rf ${ARTIFACT_FOLDER}/${ARTIFACT_LAYER_FOLDER}/
    mkdir -p ${ARTIFACT_FOLDER}/${ARTIFACT_LAYER_FOLDER}

    SHARED_LIBRARIES=$(cat /assets/swift-shared-libraries.txt | tr '\n' ' ')
    SHARED_LIBS_FOLDER=swift-shared-libs
    TEMP_LAYER_FOLDER="swift-layer"
    LAYER_TEMP_OUTPUT_FOLDER=${ARTIFACT_FOLDER}/${ARTIFACT_LAYER_FOLDER}/${TEMP_LAYER_FOLDER}

    mkdir -p $LAYER_TEMP_OUTPUT_FOLDER/$SHARED_LIBS_FOLDER/lib

    cp /assets/bootstrap $LAYER_TEMP_OUTPUT_FOLDER/
    cp /lib64/ld-linux-x86-64.so.2 $LAYER_TEMP_OUTPUT_FOLDER/$SHARED_LIBS_FOLDER/
    cp -t $LAYER_TEMP_OUTPUT_FOLDER/$SHARED_LIBS_FOLDER/lib $SHARED_LIBRARIES

    cd $LAYER_TEMP_OUTPUT_FOLDER
    zip -rq layer.zip ./*
    mv layer.zip ../
    cd ~-
    rm -r $LAYER_TEMP_OUTPUT_FOLDER

    echo "Layer: Finish packing the swift layer."

    echo "Layer: All done"
    ;;

  *) echo "Entrypoint commands skipped executing provided command:"

    exec "$@"
    ;;

esac

