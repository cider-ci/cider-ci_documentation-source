---
title: Project Configuration Specification
---
{::options parse_block_html="true" /}


# Project Configuration Specification

This part of the documentation contains the almost formal specification of the
Cider-CI configuration.


## Top Level

### Example

~~~yml
jobs:
  introduction-demo:
    name: Introduction Demo and Example Job
    description: |
      A very concise job declaration which uses the compact notation.
    task: |
      :; exit 0
      exit /b 0
~~~

### Overview

The following table lists all the legal keys in the top level project specification.

|---------------+--------------------------------------------------------------------|
| Key/Property  | Value                                                              |
|---------------+--------------------------------------------------------------------|
| `jobs`        | Map of maps, see the [jobs](#jobs) section and and the [job] page. |
| `name`        | String                                                             |
| `description` | String                                                             |
|---------------+--------------------------------------------------------------------|
{: .table .table-striped }

### Jobs

The `jobs` key introduces the declaration of jobs. The value type of the `jobs`
key is a map of maps. The key of a job is used to reference the job. See
the [job] page for the specification of a job.

  [job]: job/index.html
