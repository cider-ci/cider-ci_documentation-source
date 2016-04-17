---
title: The Task Specification
---
{::options parse_block_html="true" /}

# The Task Specification

|---------------------------------+--------------------------------------------------------------------------------------------------------------------|
| Key/Property                    | Value                                                                                                              |
|---------------------------------+--------------------------------------------------------------------------------------------------------------------|
| `aggregate_state`               | Either `satisfy-any` or `satisfy-last`, see the article [Interacting with the Environment].                        |
| `description`                   | String.                                                                                                            |
| `dispatch_storm_delay_duration` | String, representing a [duration], defaults to `1 second`. See the article [Preventing Dispatch Storms].           |
| `eager_trials`                  | Integer, defaults to `1` and limited by `max_trials`. Number of trials which will be created eagerly.              |
| `environment_variables`         | Map of strings. Subject to [inheritance].                                                                          |
| `exclusive_global_resources`    | Map of booleans. The keys indicate the resource, the values decide if the resource lock is active.                 |
| `git_options`                   | This option decides if and which submodules are cloned.  See [`git_options` in the demo project].                  |
| `key`                           | String.                                                                                                            |
| `max_trials`                    | Integer, defaults to `3`. The Maximum number of trials which will be created until the task passes.                |
| `name`                          | String.                                                                                                            |
| `ports`                         | Map of values, see the [ports] page.                                                                               |
| `script_defaults`               | Map, the values are the same as for a [script].                                                                    |
| `scripts`                       | Map of maps, see [script].                                                                                         |
| `templates`                     | Map of maps, templates files with environment variables. See [`templates` in the demo project].                    |
| `traits`                        | Map of booleans. The keys indicate the traits to match suitable executors. The values decide if the trait is used. |
| `tree_attachments`              | Map of maps, determines files to be attached to the `tree_id`.  See [`attachments` in the demo project].           |
| `trial_attachments`             | Map of maps, determines files to be attached to the `trial_id`.  See [`attachments` in the demo project].          |
|---------------------------------+--------------------------------------------------------------------------------------------------------------------|
{: .table .table-striped }

  [Interacting with the Environment]: http://cider-ci.info/articles/interacting-with-the-environment/index.html
  [Preventing Dispatch Storms]: http://cider-ci.info/articles/preventing-dispatch-storms/index.html
  [`attachments` in the demo project]: https://github.com/cider-ci/cider-ci_demo-project-bash/search?utf8=%E2%9C%93&q=attachments
  [`git_options` in the demo project]: https://github.com/cider-ci/cider-ci_demo-project-bash/search?utf8=%E2%9C%93&q=git_options
  [`templates` in the demo project]: https://github.com/cider-ci/cider-ci_demo-project-bash/search?utf8=%E2%9C%93&q=templates
  [duration]: /project-configuration/specification/other/duration.html
  [inheritance]: /project-configuration/advanced/inheritance.html
  [ports]: /project-configuration/specification/other/ports.html
  [script]: /project-configuration/specification/script.html
