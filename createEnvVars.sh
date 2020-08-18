#!/usr/bin/env bash

# This bash script creates ENV vars for local/CI build setup

# Usage:
#   ./createEnvVars.sh

echo "================================================================" 
echo ""

echo -n "iOS package name: "
read packageName
echo ""

echo -n "iOS metadata git repo SSH url: "
read metadataGitUrl
echo ""

echo -n "Apple Connect username: "
read username
echo ""

echo -n "Apple Connect password: "
read password
echo ""

echo -n "Apple Connect team id: "
read team_id
echo ""

echo -n "Create ENV vars for local builds (y/n)? "
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    # Local ENV
    BITRISE_SECRETS_FILE=".bitrise.secrets.yml"
    echo "envs:" > $BITRISE_SECRETS_FILE
    echo "- APPLE_CONNECT_USER_NAME: $username" >> $BITRISE_SECRETS_FILE
    echo "- FASTLANE_USER: $username" >> $BITRISE_SECRETS_FILE
    echo "- FASTLANE_PASSWORD: $password" >> $BITRISE_SECRETS_FILE
    echo "- IOS_PACKAGE_NAME: $packageName" >> $BITRISE_SECRETS_FILE
    echo "- APPLE_CONNECT_TEAM_ID: $team_id" >> $BITRISE_SECRETS_FILE
    echo "- IOS_METADATA_GIT_REPO_SSH_URL: $metadataGitUrl" >> $BITRISE_SECRETS_FILE
    echo "" 
    echo "================================================================" 
    echo "$BITRISE_SECRETS_FILE created with ENV vars. This file should not be shared/added to git." 
    echo "" 
    echo "Done." 
else
    # CI ENV
    echo "================================================================" 
    echo "Create Secret ENV vars in Bitrise CI with Key-Value pair" 
    echo "" 
    echo "      APPLE_CONNECT_USER_NAME: $username"
    echo "" 
    echo "      FASTLANE_USER: $username"
    echo "" 
    echo "      FASTLANE_PASSWORD: $password"
    echo "" 
    echo "      IOS_PACKAGE_NAME: $packageName"
    echo "" 
    echo "      APPLE_CONNECT_TEAM_ID: $team_id"
    echo "" 
    echo "      IOS_METADATA_GIT_REPO_SSH_URL: $metadataGitUrl"
    echo "" 
fi
