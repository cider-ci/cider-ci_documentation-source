---
title: The Context Specification
---
{::options parse_block_html="true" /}

# The Context Specification

The Context is a container for tasks. It is the main
construct of the [hierarchy and inheritance] concept.

|-------------------+---------------------------------------------------------------------------|
| Key/Property      | Value                                                                     |
|-------------------+---------------------------------------------------------------------------|
| `script_defaults` | Map, the values are the same as for a [script].                           |
| `contexts`        | Map of maps, see the [hierarchy and inheritance] mechanism.               |
| `task_defaults`   | Map, the values are the same as for a [task].                             |
| `generate_tasks`  | See the article "[An Introduction to Parallelizing Tests with Cider-CI]". |
| `tasks`           | Map of maps, each value specifies a [task].                               |
|-------------------+---------------------------------------------------------------------------|
{: .table .table-striped }


  [An Introduction to Parallelizing Tests with Cider-CI]: http://cider-ci.info/articles/parallelizing-tests/index.html#splitting-tests-automatically
  [hierarchy and inheritance]: /project-configuration/advanced/inheritance.html
  [script]: /project-configuration/specification/script.html
  [task]: /project-configuration/specification/task.html
