#!/bin/bash

echo "Starting up: Fetching Metadata from Apple Connect..."

# Execute update_metadata lane
bundle exec fastlane ios fetch_metadata
