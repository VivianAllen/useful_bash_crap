#!/bin/bash
echo "Removing previous python_pkgs_lambda_layer.zip file if it exists..."
rm python_pkgs_lambda_layer.zip

echo "Setting up working directories..."
CURRENT_DIR=$PWD
WORKING_DIR=$(mktemp -d)
PKG_DIR="$WORKING_DIR"/python
mkdir "$PKG_DIR"

echo "entering docker"


echo "Pip installing requirements.txt (in docker) to temp pkg directory..."
docker run \
    -v ${CURRENT_DIR}:/requirements_dir \
    -v ${PKG_DIR}:/pkg_dir \
    "lambci/lambda:build-python3.6" \
    /bin/sh -c "pip install -r /requirements_dir/requirements.txt -t /pkg_dir; exit"

echo "Zipping pkg directory to python_pkgs_lambda_layer.zip..."
cd "$WORKING_DIR" && zip -r "$CURRENT_DIR"/python_pkgs_lambda_layer .

echo "Cleaning up..."
cd "$CURRENT_DIR"
rm -rf "$WORKING_DIR"

echo "DONE"
