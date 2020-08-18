#!/usr/bin/env bash

METADATA_DIR="fastlane/metadata"
SCREENSHOT_DIR="fastlane/screenshots"

echo "Getting metadata..."

# Delete existing metadata + screenshots dir
rm -rf $METADATA_DIR
rm -rf $SCREENSHOT_DIR
# Clone the metadata repo
git clone $IOS_METADATA_GIT_REPO_SSH_URL
# Sync with latest changes from master branch
cd metadata-apps && git checkout master && git pull && cd ..
# Create an empty metadata directory
mkdir $METADATA_DIR
mkdir $SCREENSHOT_DIR
# Move the files from cloned repo to metadata dir
mv metadata-apps/ios/metadata/* $METADATA_DIR
mv metadata-apps/ios/screenshots/* $SCREENSHOT_DIR
