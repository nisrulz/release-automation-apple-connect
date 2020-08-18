# Developer Docs

Tools used:

- Bitrise CLI
- Fastlane

There are 5 ENV vars that need to be defined/setup in CI for this workflow to work:

1. **APPLE_CONNECT_USER_NAME**: `our_username@email.com`

    > App Connect username to login

1. **FASTLANE_USER**: `our_username@email.com`

    > App Connect username to login

1. **FASTLANE_PASSWORD**: `your_app_connect_password`

    > App Connect password to login

1. **IOS_PACKAGE_NAME**: `com.example.application`

    > Package name of your iOS application

1. **APPLE_CONNECT_TEAM_ID**: `your_app_connect_team_id`

    > App Connect teamid

1. **IOS_METADATA_GIT_REPO_SSH_URL**: `git@github.com:username/metadata-apps.git`

    > SSH url for cloning the metadata repository. Usually this repo will be private to your organization. The only thing important is that this repo should be ready to clone by either Bitrise CI or you (locally).

### Create processed Secret ENV vars via script
In order to simplify the process, you can use the `createEnvVars.sh` script like below:

```bash
./createEnvVars.sh
```

This script will ask for relevant required info and create either your local `.bitrise.secrets.yml` file with all ENV vars populated so you can use with Bitrise CLI or output to console processed Secret ENV vars which can be copy pasted to Bitrise CI @Bitrise.io under the set workflow.

## Work on Bitrise CI

1. Setup the **Secret** ENV vars for the repo.

1. Replace the online `bitrise.yml` file's content with below:
    ```
    ---
    format_version: 1.4.0
    default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
    workflows:
      update-metadata:
        steps:
        - activate-ssh-key:
            run_if: '{{getenv "SSH_RSA_PRIVATE_KEY" | ne ""}}'
        - git-clone: {}
        - script:
            title: Continue from repo
            inputs:
            - content: "./scripts/update_metadata.sh"
      update-screenshots:
        steps:
        - activate-ssh-key:
            run_if: '{{getenv "SSH_RSA_PRIVATE_KEY" | ne ""}}'
        - git-clone: {}
        - script:
            title: Continue from repo
            inputs:
            - content: "./scripts/update_screenshots.sh"
    ```

## Work on Local

In order to set this up locally you will need to

1. Create a `.bitrise.secrets.yml` file. This is already gitignored.

    ```bash
    touch .bitrise.secrets.yml
    ```

2. Populate `.bitrise.secrets.yml` file as below:

    ```bash
    envs:
    - APPLE_CONNECT_USER_NAME: our_username@email.com
    - FASTLANE_USER: your_username@email.com
    - FASTLANE_PASSWORD: your_password
    - IOS_PACKAGE_NAME: com.example.app
    - APPLE_CONNECT_TEAM_ID: 11111111
    - IOS_METADATA_GIT_REPO_SSH_URL: git@github.com:username/metadata-apps.git
    ```

3. To execute a workflow, run `bitrise run workflow_name`. Possible workflows:

    - `bitrise run fetch-metadata`: Fetch existing metadata in Appstore
    - `bitrise run update-metadata`: Update metadata in Appstore
    - `bitrise run update-screenshots`: Update metadata in Appstore

## Metadata

Metadata is stored under the path `fastlane/metadata/` and screenshots under the path `fastlane/screenshots/`

- The `fetch-metadata` workflow downloads the metadata inside the `fastlane/metadata/` directory and screenshots under the `fastlane/screenshots/` directory, with data segregated into localized folders such as **en-GB**, **de-DE**, etc.
- The `update-metadata` workflow uploads the metadata inside the `fastlane/metadata/` directory, with data picked from localized folders such as **en-GB**, **de-DE**, etc.
- The `update-screenshots` workflow uploads the screenshots inside the `fastlane/screenshots/` directory, with data picked from localized folders such as **en-GB**, **de-DE**, etc.

It is upto you to decide how to populate `metatdata` directory. 

For this workflow, we utilize git repo to sync with a `metadata-apps` private repo to populate the `fastlane/metadata` directory just before uploading metadata. For this reason you need to setup and provide the `IOS_METADATA_GIT_REPO_SSH_URL` in the ENV vars.

Any update should be made to the `metadata-apps` and this workflow will sync with the latest changes.

To setup `metadata-apps` repo, simply follow along:
1. Create a new repo named `metadata-apps`. It can be private.
1. Use the `fetch-metadata` workflow to get the initial directory structure.
1. Cut and paste it in your `metadata-apps` repo under `ios` directory.
1. Add to git, commit and push to remote `metadata-apps` repository.
1. When you want to make an update to the metadata, directly update the files inside the `metadata-apps` repository under `ios` directory and sync it with remote.
1. When the next time `update-metadata` workflow executes, it will sync and pull the latest changes from the `metadata-apps` repository.

Below is a screenshot of how the `metadata-apps` repository directory structure would look like:

![metadata-apps repository](./img/metadata-v-app-dir-sc.png)