---
title: The Script Specification
---
{::options parse_block_html="true" /}

#  The Script Specification

## Overview

|----------------------------------+----------------------------------------------------------------------------------------------------------------------|
| Key/Property                     | Value                                                                                                                |
|----------------------------------+----------------------------------------------------------------------------------------------------------------------|
| `body`                           | String, the actual script being executed.                                                                            |
| `description`                    | String.                                                                                                              |
| `environment_variables`          | Map of strings. Subject to [inheritance].                                                                            |
| `exclusive_executor_resource`    | String, see [`exclusive_executor_resource` on this page](#exclusive_executor_resource).                              |
| `ignore_abort`                   | Boolean, defaults to `false`. The script will not be skipped or aborted if set to `true`.                            |
| `ignore_state`                   | Boolean, defaults to `false`. The state of this will not be taken into account for the aggregate state of the trial. |
| `key`                            | String, defaults to the key in the scripts map.  Uses to reference this script in `start_when` for example.          |
| `name`                           | String.                                                                                                              |
| `start_when`                     | Map of maps, see [`start_when` and `terminate_when` on this page](#start_when).                                      |
| `template_environment_variables` | Boolean, defaults to `true`.                                                                                         |
| `terminate_when`                 | Map of maps. Opposite of `start_when`, each value specifies when to abort a script prematurely.                      |
| `timeout`                        | String, representing a [duration], defaults to `3 minutes`. Determines when a script will be forcefully terminated.  |
|----------------------------------+----------------------------------------------------------------------------------------------------------------------|
{: .table .table-striped }



<!--- ###################################################################### -->

## The `exclusive_executor_resource` Property
{: #exclusive_executor_resource}

<div class="row"> <div class="col-md-6">

The `exclusive_executor_resource` **prevents** two (or more) scripts with the
same value to be **executed in parallel** on the **same executor**. The value
is **honored across scripts belonging to different trials/tasks**, which is the
prevalent use case.

The value is a string which can be **templated**. See also the [templating]
page. Templating is always enabled: `{{` and `}}` is to be avoided if no
templating is intended.

If a script with a certain value is currently executing and an other script
with the same value becomes eligible for being started, i.e. it fulfills the
conditions given by `start_when`, its state will move from `pending` to
`waiting`. It will be started when the "resource becomes available".

There are **no guarantees** with respect to the **order** if there are multiple
scripts with the same value in `waiting` state.

**Deadlock situations are impossible** because every script has only one
`exclusive_executor_resource` property.

</div> <div class="col-md-6">

~~~yaml
environment_variables:
  RUBY_VERSION: 2.2.4
scripts:
  bundle:
    # never run `bundle install` in parallel,
    # it is likely to break your ruby installation
    exclusive_executor_resource: "ruby_{{RUBY_VERSION}}"
    bundle: |
      set -eux
      rbenv shell $RUBY_VERSION
      bundle install

~~~
</div> </div>


<!--- ###################################################################### -->


## The `start_when` and `terminate_when` Properties
{: #start_when}

<div class="row"> <div class="col-md-6">

The `starte_when` property is used to define dependencies between scripts
belonging to the same trial. The article article [Testing Services] has further
information about the ratio of this feature.

The `terminate_when` property defines conditions to specify premature
termination of a script. It is not as useful as `start_when` property. It is
mostly useful to achieve faster termination of a running script when some other
script fails.

Both properties use a map of maps to specify a collection of dependencies. The
keys can be freely chosen, for example to describe the dependency. The items
are combined with logical conjunction: a script will be started if and only if
**all dependencies are satisfied**.

|--------------+-------------------------------------------------------------------------------------------------------------------|
| Key/Property | Value                                                                                                             |
|--------------+-------------------------------------------------------------------------------------------------------------------|
| `script_key` | String, the key of the script to reference.                                                                       |
| `states`     | Array of states out of: `aborted`, `defective`, `executing`, `failed`, `passed`, `pending`, `skipped`, `waiting`. |
|--------------+-------------------------------------------------------------------------------------------------------------------|
{: .table .table-striped }


</div> <div class="col-md-6">

~~~yaml
scripts:
  prepare:
    body: do some preparing
  run-service:
    body: run some service and keep it running
    terminate_when:
      'test is in terminal state':
        script_key: test
        states: ['aborted', 'defective', 'failed', 'passed', 'skipped']
    ignote_state: true
  test:
    body: test
    start_when:
      'prepared':
        script_key: prepare
        states: [ "passed" ]
      'service is running':
        script_key: run-service
        states: [ "executing"]
  cleanup:
    body: do some cleanup
    start_when:
      'start when test is in terminal state':
        script_key: test
        states: ['aborted', 'defective', 'failed', 'passed', 'skipped']

~~~
</div> </div>


  [templating]: /project-configuration/specification/other/templating.html
  [duration]: /project-configuration/specification/other/duration.html
  [Testing Services]: http://cider-ci.info/articles/testing-services/index.html
