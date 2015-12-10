---
title: Project Configuration File
---
{::options parse_block_html="true" /}

# The Cider-CI Configuration File {#configuration-file}
{:.no_toc}

* Will be replaced with the ToC, excluding the "Contents" header
{:toc}


This page documents the contents of the Cider-CI configuration file. It defines
and specifies available _jobs_, relations between them, and all other
properties which are available to build tasks, scripts and execute them.

The section [Getting Started](#getting-started) on this pages features
a complete and self contained example.

The following locations are valid: `cider-ci.yml`, `.cider-ci.yml`,
`cider-ci.json`, or `.cider-ci.json`. They are looked up precisely in the order
given. The first one found will be used and any others ignored. The valid
syntax is as the name suggests either [YAML](http://www.yaml.org/) or
[JSON](http://json.org/).

YAML is technically a superset of JSON, by capability and syntax! Note that
Cider-CI uses only features of YAML which can be presented in JSON. We yet
prefer YAML for examples in this documentation as we believe it is easier to
read.
{: .text-warning}


## The Configuration File

### Getting Started
<div class="row"> <div class="col-md-6">

The following example specifies one job with one task and inside a very simple script. It is a minimal but fully functional Cider-CI configuration file and part of [Bash Demo Project for Cider-CI] in the file [`introduction.yml`][].


</div> <div class="col-md-6">
~~~yaml
jobs:
  intro-demo:
    name: Introduction Demo and Example.
    task-defaults:
      traits: [bash]
    task: test a = a
~~~
</div> </div>

### Canonical Syntax versus Compact Notation

<div class="row"> <div class="col-md-6">

The previous example is written in _compact notation_. The compact notation is
short and easy to read. However, advanced configuration options are only
accessible via the _canonical syntax_. The canonical syntax is authoritative
with respect of evaluation and this documentation.

<span class="text-warning">
Including files and using the compact notation together can end with unexpected
results and should be avoided. </span> The [Advanced Topics] page contains some
background information on this.

</div> <div class="col-md-6">

~~~yaml
jobs:
  intro-demo:
    key: intro-demo
    name: Introduction Demo and Example.
    context:
      task-defaults:
        traits:
          bash: true
      tasks:
        '0':
          scripts:
            main:
              body: test a = a
~~~

</div> </div>


### Maps and Arrays

<div class="row"> <div class="col-md-6">

The omnipresence of maps and the absence of arrays in the canonical notation is
apparent. Maps are generally favored in Cider-CI because they enable
composition by the means of merging and inclusion. This is discussed in the
[Advanced Topics] page.

The example from above would be a legal standalone configuration file but it is
actually included from the configuration file of the [Bash Demo Project for
Cider-CI] which is similar to the following example.

</div> <div class="col-md-6">

    _cider-ci_include:
      - .cider-ci/jobs/attachments.yml
      - .cider-ci/jobs/introduction.yml
      - .cider-ci/jobs/timeout.yml
  {: .language-yaml}

</div> </div>


  [Advanced Topics]: /project-configuration/advanced.html
  [Bash Demo Project for Cider-CI]: https://github.com/cider-ci/cider-ci_demo-project-bash
  [`introduction.yml`]: /demo-project/cider-ci/jobs/introduction.yml


