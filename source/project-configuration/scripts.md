---
title: Project Configuration - Scripts
---
{::options parse_block_html="true" /}

# Scripts

The `scripts` key within a [Task] introduces a map of maps,  see [Map of
Maps] in [Advanced Topics], each mapping to a [Script](#script).

## Script


|----------------------------------+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Key/Property                     | Presence                     | Value                                                                                                                                                                                         |
|----------------------------------+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `body`                           | required                     | String - Literally a script to be executed. Examples: [introduction][]                                                                                                                        |
| `ignore-abort`                   | defaults to `false`          | Boolean - The script will continue to execute even in the case the trial is being aborted. Examples: [abort_and_retry][]                                                                      |
| `ignore-state`                   | defaults to `false`          | Boolean - The state of the script will not be taken in account when evaluation the trial. Examples: [script-dependencies][]                                                                   |
| `name`                           | yes[^r]                      | String - The visible name of the script.                                                                                                                                                      |
| `start-when`                     | optional                     | Map (or Array) of Maps - The scripts and their state on which this script will be started (combined with conjunction). Examples: [script-dependencies][]                                      |
| `template-environment-variables` | defaults to `false`          | Boolean - Jinja2 like templates in environment variables are recursively substituted[^t] when set to true. Examples: [environment-variables][]                                                |
| `templates`                      | optional                     | Array of Maps each containing a `src` and `dest` key - Jinja2 like templated files are substituted with environments-variable known from the context of Cider-CI[^t]. Examples: [templates][] |
| `terminate-when`                 | optional                     | Map (or Array) of Maps - The scripts and their state on which this script will be forcefully terminated (combined with conjunction). Examples: [script-dependencies][]                        |
| `timeout`                        | defaults to `3 Minutes`[^ec] | String or Integer - Timeout in seconds (integer) or human readable duration (string) after which the script will be forcefully terminated. Examples: [timeout][]                              |
|----------------------------------+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
{: .table .table-striped }


  [^r]: Defaults to the string which represents the key.
  [^ec]: The default value is configurable per instance.
  [^t]: Values include environment variables defined in the Cider-CI task or script specification, and environment variables set by Cider-CI, e.g. the `CIDER_CI_TREE_ID`.
      It is not possible to determine environment variables given by the environment of the executing user reliably before the script is started and hence those are not considered.


  [Task]: /project-configuration/tasks.html#task
  [Map of Maps]: /project-configuration/advanced.html#map-of-maps
  [Advanced Topics]: /project-configuration/advanced.html

  [abort_and_retry]: /demo-project/cider-ci/jobs/abort_and_retry.yml
  [environment-variables]: /demo-project/cider-ci/jobs/environment-variables.yml
  [introduction]: /demo-project/cider-ci/jobs/introduction.yml
  [script-dependencies]: /demo-project/cider-ci/jobs/script-dependencies.yml
  [templates]: /demo-project/cider-ci/jobs/templates.yml
  [timeout]: /demo-project/cider-ci/jobs/timeout.yml
