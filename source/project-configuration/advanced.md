---
title: Advanced Project Configuration
---
# Advanced Topics
{:.no_toc}

* Will be replaced with the ToC, excluding the "Contents" header
{:toc}

This page describes advanced features and techniques to keep the specification
of the [Cider-CI Configuration File] maintainable and non repetitive.


## Map of Maps - Conceptual Mapping to Arrays
{: #map-of-maps}

Maps are generally favored over arrays in the [Cider-CI Configuration File]. Maps are in
general more flexible and in particular enable inclusion, see the section
[Including Files](#including-files).[^map-order] The occurrences of  "Map of
Maps" are most prominently directly underneath `jobs`, `tasks` and `scripts`.
During the evaluation of the configuration these  maps can be thought of as if they
are transfered to arrays. The keys `name` and `key` on the second level are
affected by this transformation. If the map on the second level does not have
a `name` property it will be set to the name of the key. An existing `name`
would not be overwritten. The property with the key `key` will be
added/overridden with the value set to the name of the key.

    jobs:
      job-x:
        key: I will be overwritten.
      job-y:
        name: I will persist.
  {: .language-yaml}

    jobs:
    - key: job-x
      name: job-x
    - key: job-y
      name: I will persist.
  {: .language-yaml}


[^map-order]: The general downside is that maps, unlike arrays, don't guarantee a stable order (which is irrelevant for our use case).

## Including Files
{: #including-files}

One or more  _YAML_ files can be included via the `_cider-ci_include` key. The
value of `_cider-ci_include` is a string or an array of strings.

The `_cider-ci_include` may appear in any map at any level in the [Cider-CI
Configuration File].

The top level element of the included file must be map. We note that this is
not a restriction in what can be achieved with inclusion. The only allowed
format for included files is `YAML` at this time. However, the content must
compatible to the `JSON` format. The `JSON` format is more restrictive than
`YAML`, it restricts key to be strings for example.

A included map is merged into the current context with the
[Deep-Merge](#deep-merge) strategy: `deep_merge( current-map, file-map)`.

If multiple files are included by specifying an array the map corresponding to
the map of the first file is merged in the current context, then the map of the
second file and so forth.

It is legal to use the `_cider-ci_include` statement in files which are
themselves to be included. The merging strategy will by applied recursively in
[DFS][] order until all includes are satisfied. It is illegal to define
circular references.

  [DFS]: http://en.wikipedia.org/wiki/Depth-first_search

## Generating Tasks
{: #generating-tasks}


~~~yml
_cider-ci_generate-tasks:
  include-match: spec/.*_spec.rb
  exclude-match: spec/features.*_spec.rb
~~~

The `_cider-ci_generate-tasks` directive within the context or a subcontext can
be used to generate tasks based on files checked into the repository. This is
demonstrated in [generate-tasks] example and more comprehensively
[here](https://github.com/Madek/madek-webapp/blob/master/cider-ci/jobs/feature-tests.yml#L127-L128).
Conceptually, the result of `git ls-tree` is filtered according to the values
of `include-match` and `exclude-match` which are interpreted as regular
expressions.

The result is a map of maps which is structurally equivalent to the value of
the `tasks` key in the context. The full filename, with respect to the root
of the repository, is used as `key` and is also set in the environment variable
`CIDER_CI_TASK_FILE`.

Additionally, an already existing `tasks` directive in the current context
would be [deep-merged](#deep-merge) with the one generated where values from
the existing `tasks` directive would override those generated. Thus custom
directives can be set on a task basis even for generated tasks as shown in the
following example extracted from
[here](https://github.com/Madek/madek-webapp/blob/master/cider-ci/jobs/feature-tests.yml#L97-L128).


~~~yml
tasks:
  "spec/features/custom_root-url_spec.rb":
    environment-variables:
      RAILS_RELATIVE_URL_ROOT: /my-test

_cider-ci_generate-tasks:
  include-match: spec/features.*_spec.rb
~~~

## Subcontexts and Inheritance {#subcontexts}

The main context, i.e. the map where tasks and related structures are defined,
may contain the `subcontexts` directive. A subcontext can have exactly the same
keys and values as the context. This includes the `subcontexts` directive
itself.

Subcontexts provide a way of inheritance which itself provides means to isolate
some properties while maintaining shared properties in one place. A task in
a subcontext not only inherits the directives of its own `task-defaults` but
also those of the parent context. The precise rule is that the defaults from
the context are passed down by applying the [Deep-Merge](#deep-merge) strategy
recursively: `deep_merge( deep_merge( task_defauls parent context,
task-defaults current context), task)`.

## Canonical Syntax and Compact Notation

Some parts of the Cider-CI configuration file can be written in a *compact
notation*. The compact notation is short and easy to read. But it does not
compose well and there are potential conflicts with [including files][].

The notation shortcuts can only be meaningfully evaluated in their context. In
other words: the compact notation is context sensitive. Including files with the
deep merge strategy happens in a context free manner. It follows that the
compact notation can only be evaluated[^compact-eval] after the inclusion has
been finished. Now, since the compact notation uses structures which can not be
merged there is a potential risk of loosing information without intention.

[^compact-eval]: Structures written in compact notation are actually not
    evaluated. They are converted into canonical syntax which is then used
    to build jobs, tasks and so on.

Using booth concepts _compact notation_ and inclusion (resp. merging) across
structures will likely end with undesired results and should be avoided.
{: .text-danger}

  [including files]: #including-files


## The Deep-Merge Strategy {#deep-merge}

Inclusion and inheritance use a particular merging strategy which we call the
_Deep-Merge_ strategy. The canonical definition of _Deep-Merge_ is mnemonic and
easy to understand. The following almost formal definition will help to clarify
doubts:

Let `m1` and `m2` be a maps, and let `m` be the result of `deep_merge(m1, m2)`
Then the  following holds true:

1. If the key `k1` with the value `v1` is present in `m1` but not in `m2`, then
  the key value pair `(k1,v1)` is be present in `m`.

2. If the key `k2` with the value `v2` is present in `m2` but not in `m1`, then
  the key value pair `(k2,v2)` is be present in `m`.

3. If `k` is present in `m1` and `m2`

    1. and  `v1` and `v2` are both maps, then the pair `(k,  deep_merge(v1, v2))` is present in `m`.

    2. otherwise the pair `(k,v2)` is present in `m`.


  [Cider-CI Configuration File]: /project-configuration/configuration-file.html
  [generate-tasks]: /demo-project/cider-ci/jobs/generate-tasks.yml

