---
title: Project Configuration - Scripts
---
{::options parse_block_html="true" /}

# Scripts

The `scripts` key within a [Task] introduces a map of maps,  see [Map of
Maps] in [Advanced Topics], each mapping to a [Script](#script).

## Script


|------------------+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Key/Property     | Presence      | Value                                                                                                                                                         |
|------------------+---------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `body`           | required      | String - Literally a script to be executed. Examples: [introduction][]
| `name`           | yes[^r]       | String - The visible name of the script.
| `start-when`     | optional      | Array of Maps - The scripts and their state on which this script will be started (combined with conjunction). Examples: [script-dependencies][]
| `terminate-when` | optional      | Array of Maps - The scripts and their state on which this script will be forcefully terminated (combined with conjunction). Examples: [script-dependencies][]
| `ignore-state`   | default false | Boolean - The state of the script will not be taken in account when evaluation the trial. Examples: [script-dependencies][]
| -
{: .table .table-striped }


  [^r]: Defaults to the string that represents the key.

  [Task]: /project-configuration/tasks.html#task
  [Map of Maps]: /project-configuration/advanced.html#map-of-maps
  [Advanced Topics]: /project-configuration/advanced.html

  [introduction]: /demo-project/cider-ci/jobs/introduction.yml
  [script-dependencies]: /demo-project/cider-ci/jobs/script-dependencies.yml

