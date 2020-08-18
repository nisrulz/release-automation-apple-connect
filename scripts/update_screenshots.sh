#!/bin/bash

echo "Starting up: Update Screenshots for Apple App Store..."

# Install dependencies
bundle install

# Get latest metadata from repo
./scripts/get_metadata.sh

# Execute update_sreenshots lane
bundle exec fastlane ios update_screenshots
