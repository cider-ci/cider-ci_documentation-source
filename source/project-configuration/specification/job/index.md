---
title: The Job Specification
---
{::options parse_block_html="true" /}

# The Job Specification


|-----------------------+------------------------------------------------------------------------------------------|
| Key/Property          | Value                                                                                    |
|-----------------------+------------------------------------------------------------------------------------------|
| `context`             | Map of properties, see the [context] and [inheritance] page.                             |
| `depends_on`          | Map of maps, see the [dependencies and triggers] page.                                   |
| `description`         | String, used in the user interface.                                                      |
| `empty_tasks_warning` | Boolean, defaults to `true`. Enables or suppresses warnings when the tasks list is empty. |
| `key`                 | String, used to reference this job. Defaults to the value of the key in the jobs map.    |
| `name`                | String, used in the user interface. Defaults to the key of the job.                      |
| `priority`            | Integer, defaults to `0`. See the [execution priority] page.                             |
| `run_when`            | Map of maps, see the [dependencies and triggers] page.                                   |
| `task`                | Used in [compact notation]. Conflicts with [context].                                    |
| `task_defaults`       | Used in [compact notation]. Conflicts with [context].                                    |
| `tasks`               | Used in [compact notation]. Conflicts with [context].                                    |
|-----------------------+------------------------------------------------------------------------------------------|
{: .table .table-striped }


  [compact notation]: /project-configuration/configuration-file.html#canonical-syntax-versus-compact-notation
  [context]: /project-configuration/specification/context.html
  [dependencies and triggers]: /project-configuration/specification/job/dependencies-and-triggers.html
  [execution priority]: /project-configuration/advanced/execution-priority.html
  [inheritance]: /project-configuration/advanced/inheritance.html
  [triggers]: /project-configuration/specification/triggers.html
