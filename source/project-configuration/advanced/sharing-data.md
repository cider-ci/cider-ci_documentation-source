---
title: Sharing Data
---
{::options parse_block_html="true" /}

# Sharing Data

We discuss how Cider-CI enables the sharing and reuse of configuration data
within and even across projects.

## The `include` Statement

<div class="row"> <div class="col-md-6">

The value of `include` is in its simplest form a string which represents a path
to a JSON or YAML file in the project. Multiple files can be referenced by an
array of strings. The `include` keyword is necessarily embedded in a map. The
**top level element** of the referenced file **must be a map**. This is
necessary so the `deep-merge` operation discussed on the [composing data] can
be applied.

We use the symbol `⊕` to denote `deep-merge` in the following. Let the
`include` statement be contained in the map `M`. The maps of the included files
are denoted with `M1`, `M2`, and so forth where the number corresponds to the
index in the array. Then the resulting map is given by `M1 ⊕ M2 ⊕ ... ⊕ M`. The
key observation is that conflicting **keys with higher index override those
with lower index** and that **keys of the map with the include statement have
the highest precedence** of all.

The `include` directive may appear in **any map at any level**. Further,
**files being included may contain `include` statements**, too. The merging
strategy will by applied **recursively in [DFS][] order** until all `include`
statements have been replaced. It is illegal to define circular references,
they will result in an error.

</div> <div class="col-md-6">

~~~yaml
include: cider-ci/shared.yml
~~~

~~~yaml
include:
  - cider-ci/meta/context.yml
  - cider-ci/tests/context.yml
~~~


</div> </div>



## Sharing Configuration Data between Projects


<div class="row"> <div class="col-md-6">

Configuration data can be shared between projects via [git submodules]. To
specify the submodule path the include statement must be given in its **full
form**: an **array of maps each containing a `path` and `submodule`** key. The
value of the `path` is string representing the file in the project or
submodule. The value of the `submodule` is an array of strings. Each string
represents the path to the submodule in the project. The array enables
references to nested submodules.


Every referenced **submodule** must be configured as a **project in the
Cider-CI instance** and the **referenced commit** must be known by the
**Cider-CI** instance.


</div> <div class="col-md-6">

~~~yaml
include:
  - path: cider-ci/meta/context.yml
  - path: cider-ci/tests/context.yml
~~~

~~~yaml
include:
  - path: cider-ci/tests.yml
    submodule: ['builder']
  - path: cider-ci/jobs/integration-tests.yml
    submodule: ['integration-tests']
~~~
</div> </div>


  [DFS]: http://en.wikipedia.org/wiki/Depth-first_search
  [composing data]: /project-configuration/advanced/composing-data.html
  [git submodules]: https://git-scm.com/docs/git-submodule
