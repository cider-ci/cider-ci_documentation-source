
This documentation focuses on the specification by which Cider-CI composes
_builds_, _tasks_ and _trials_.


## The Main Context {#main-context}

    name: Top level context
    tasks:
      list_directory:
        name: List top level project directory
        scripts: 
          main:
            body: ls -lah
  {: .language-yaml}

|-----------------+----------+------------------------------------------|
| Key             | Required | Value                                    |
|-----------------+----------+------------------------------------------|
| `name`          | yes      | string                                   |
| `tasks`         | no       | array or map, see [tasks](#tasks)        |
| `task_defaults` | no       | map, see [task_defaults](#task_defaults) |
|-----------------+----------+------------------------------------------|
{: .table .table-striped}

## `tasks` {#tasks}

## `task_defaults` {#task_defaults}

The values of the key `task_defaults` can be exactly the same of those of the
key `task`, see [Task](#task).  However, non of them are are required.  When
a tasks is build the values of `task_defaults` and `task` are merged, see
[Deep-Merge](#deep-merge).

### `tasks` - The Task {#task}

|--------------+----------+----------------------------------------|
| Key          | Required | Value                                  |
|--------------+----------+----------------------------------------|
| `git_options` | no       | see [The Git Options][]          |
| `name`       | yes      | string                                 |
| `scripts`    | yes      | array or map; see [Script](#script)    |
| `traits`     | no       | map to booleans; see [traits](#traits) |
|--------------+----------+----------------------------------------|
{: .table .table-striped}


### `traits` - Traits 

The `traits` key can occur in a [task](#task) or in the
[task_defaults](#task_defaults).  The value is a map to booleans. Every key
with a true value is taken into account to match a suitable executor. 

    task_defaults:
      traits:
        linux: true
  {: .language-yaml}


### `scripts` - The Script {#script}

|---------+----------+---------+-----------------------------------------------------------------|
| Key     | Required | Default | Value                                                           |
|---------+----------+---------+-----------------------------------------------------------------|
| `name`  | yes      |         | string                                                          |
| `body`  | yes      |         | string, body script of the (shell) script to be executed        |
| `order` | no       | 0       | integer, determines the order in which the scripts are executed |
|---------+----------+---------+-----------------------------------------------------------------|
{: .table .table-striped}


### `git_options` - The Git Options  {#git-options}

The key `git_options` is honored in a tasks and specifies behavior when cloning
and checking out submodules.

    git_options: 
      submodules: 
        clone: true 
        timeout: 30
  {: .language-yaml}

 
|------------------------+---------+------------------------------------------------------------|
| Key                    | Default | Value                                                      |
|------------------------+---------+------------------------------------------------------------|
| `submodules`/`clone`   | False   | boolean, submodules are only cloned when this is _truthy_  |
| `submodules`/`timeout` | 200     | integer, submodule update (i.e. clone)  timeout in seconds |
|------------------------+---------+------------------------------------------------------------|
{: .table .table-striped}

See also the following comprehensive [submodule example][] in the [Bash Demo Project][].



  [Bash Demo Project]: https://github.com/cider-ci/cider-ci_demo-project-bash
  [Execution properties]: #execution-properties
  [The Git Options]: #git-options
  [submodule example]: https://github.com/cider-ci/cider-ci_demo-project-bash/blob/master/.cider-ci/shared/submodule_context.yml
