#!/bin/bash

echo "Starting up: Update Metadata for Apple App Store..."

# Install dependencies
bundle install

# Get latest metadata from repo
./scripts/get_metadata.sh

# Execute update_metadata lane
bundle exec fastlane ios update_metadata
