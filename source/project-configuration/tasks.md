---
title: Project Configuration - Tasks
---
{::options parse_block_html="true" /}

# Tasks



The tasks of a job are defined within the `context` structure of
a [job](/project-configuration/jobs.html#job).
The `tasks` key within a context introduces a map of maps,  see [Map of
Maps] in [Advanced Topics], each mapping to a [Task](#task).


## Context


|----------------------------+--------------+----------------------------------------------------------------------------------------------------------------------|
| Key/Property               | Presence     | Value                                                                                                                |
|----------------------------+--------------+----------------------------------------------------------------------------------------------------------------------|
| `script-defaults`          | optional     | Map - Every [script][] will inherit these properties. Examples: [exclusive-executor-resource], [script-dependencies] |
| `subcontexts`              | optional     | Map - An inheritance mechanism, see the also the [Advanced Topics][] page. Example: [contexts]                       |
| `task-defaults`            | optional     | Map - Every [task](#task) in the scope of this context will inherit these properties. Example: [contexts]            |
| `_cider-ci_generate-tasks` | optional     | Map - See [Generating Tasks] in [Advanced Topics].  Example: [generate-tasks]                                        |
| `tasks`                    | optional[^t] | Map of Maps - See the [task](#task).                                                                                 |
|----------------------------+--------------+----------------------------------------------------------------------------------------------------------------------|
{: .table .table-striped }
[^t]: The presence of the `tasks` property  and its content is optional from
      the configuration file perspective. However, a job without tasks makes no sense
      in Cider-CI and will result with the state `failed`.


## Task
{: #task}


|------------------------------+---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Key/Property                 | Presence      | Value                                                                                                                                                      |
|------------------------------+---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `eager-trials`               | defaults to 1 | Integer - Number of trials which are instantiated eagerly. Example: [eager_and_retry]                                                                      |
| `environment-variables`      | optional      | Map - Declares available environment variables during execution of each script. Example: [environment-variables]                                           |
| `exclusive-global-resources` | optional      | Map - Ensures that there is at most one trial executing at any point in time for an any `exclusive-global-resource`. Example: [exclusive-global-resources] |
| `git-options`                | optional      | Map - Specifies whether git submodules are checked cloned for execution, too. Example: [git-submodules]                                                    |
| `max-auto-trials`            | default 3     | Integer - Maximal number of trials which are instantiated automatically. Example: [eager_and_retry]                                                        |
| `name`                       | yes[^r]       | String - The visible name of the task.                                                                                                                     |
| `ports`                      | optional      | Map - Finds, occupies and publishes a port while processing the trial. Example: [ports]                                                                    |
| `scripts`                    | optional      | Map of Maps -  See [script][].                                                                                                                             |
| `traits`                     | optional      | Map of Booleans - Executors are matched on by the keys with true value.  Example: [introduction]                                                           |
| `tree-attachments`           | optional      | Map - Declares files which are attached to the `tree-id`. Example: [attachments]                                                                           |
| `trial-attachments`          | optional      | Map - Declares files which are attached to the trial. Example: [attachments]                                                                               |
|------------------------------+---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------|
{: .table .table-striped }



  [^r]: Defaults to the string that represents the key.
  [script]: /project-configuration/scripts.html#script
  [Advanced Topics]: /project-configuration/advanced.html
  [Generating Tasks]: /project-configuration/advanced.html#generating-tasks


  [attachments]: /demo-project/cider-ci/jobs/attachments.yml
  [contexts]: /demo-project/cider-ci/jobs/contexts.yml
  [eager_and_retry]: /demo-project/cider-ci/jobs/eager_and_retry.yml
  [environment-variables]: /demo-project/cider-ci/jobs/environment-variables.yml
  [exclusive-executor-resource]: /demo-project/cider-ci/jobs/exclusive-executor-resource.yml
  [exclusive-global-resources]: /demo-project/cider-ci/jobs/exclusive-global-resources.yml
  [generate-tasks]: /demo-project/cider-ci/jobs/generate-tasks.yml
  [git-submodules]: /demo-project/cider-ci/jobs/git-submodules.yml
  [introduction]: /demo-project/cider-ci/jobs/introduction.yml
  [ports]: /demo-project/cider-ci/jobs/ports.yml
  [script-dependencies]: /demo-project/cider-ci/jobs/script-dependencies.yml
