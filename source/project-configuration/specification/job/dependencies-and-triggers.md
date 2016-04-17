---
title: Dependencies and Triggers
---
{::options parse_block_html="true" /}

# Dependencies and Triggers

A [job] can have dependencies to other jobs and triggers which
are in syntax and structure very similar.

## `run_when` Triggers

The `run_when` statement cause a job to be run when any of the specified states
is satisfied (unless the job already exists or a dependency prevents it). The
type must be `job` or `branch`.






  [job]:/project-configuration/specification/job/index.html
