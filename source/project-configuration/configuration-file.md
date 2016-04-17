---
title: Project Configuration File
---
{::options parse_block_html="true" /}


# The Cider-CI Configuration File {#configuration-file}
{:.no_toc}

* Will be replaced with the ToC, excluding the "Contents" header
{:toc}

Cider-CI reads the specification to create and run jobs from a file in the top
level directory of your project. This page gives an introduction how to write
a Cider-CI project file. The more formal [Cider-CI Project Specification] lists
all available keys and configuration options of Cider-CI.



## Filenames

Cider-CI will look for the following files to read the configuration:

0. `cider-ci.yml`,
0. `.cider-ci.yml`,
0. `cider-ci.json`, and
0. `.cider-ci.json`.

The first file found will be used and any further will be ignored. The Cider-CI
User Interface will show a warning if none of the possible configuration files
have been found.

## Accepted Formats

As indicated by the extension of the files Cider-CI accepts either
[YAML](http://www.yaml.org/) or [JSON](http://json.org/) format. YAML is
technically a superset of JSON, by capability and syntax. Cider-CI uses only
features of YAML which can be presented in JSON. We prefer to use YAML for
examples in this documentation.


## Getting Started
<div class="row"> <div class="col-md-5">

The example specifies one job with one task and inside a very simple script. It
exits with status 0 which indicates that the script has `passed`. The script
itself is written so it will work with under either _Linux_, _Mac OS_, or
_Windows_.


</div> <div class="col-md-7">
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
</div> </div>


## Canonical Syntax versus Compact Notation

<div class="row"> <div class="col-md-5">

The previous example is written in _compact notation_. The compact notation is
short and easy to read. However, many configuration options can not be
expressed in compact notation and thus only simple jobs can be written in this
format.

Internally Cider-CI converts the _compact notation_ into its _canonical syntax_
before evaluating it. The same configuration in _canonical syntax_ would
read like the example given here.

</div> <div class="col-md-7">

~~~yaml
jobs:
  introduction-demo:
    key: introduction-demo
    name: Introduction Demo and Example Job
    description: A very concise job declaration which uses the compact notation.
    context:
      tasks:
        '0':
          scripts:
            main:
              body: |
                :; exit 0
                exit /b 0
~~~

</div> </div>


## Validation of the Specification

Much of what is happening inside Cider-CI adheres to the [fail-fast] principle.
To that end Cider-CI has a **validator** which will parse the project
configuration. It will show a warnings and prevent any execution when it
encounters **unspecified keys**, if **values are of wrong type**, or if they
**can not be parsed**.

On the one hand the validator might feel annoying at times. But we believe that
such a rigorous validation is a very important quality of a CI system. In the
end it lets you write your configuration faster and more efficient since it
frees you from double and triple checking it.

## Reserved Keywords

The keywords of the maps used in the Cider-CI configuration play important
roles. In the case of a job the keyword is used to identify a job uniquely and
reference it when declaring dependencies for example. Those keywords may be
chosen freely with a few exceptions.

{: .text-warning}
The keyword `include` and any keyword
starting with `_cider-ci` is reserved and may not be used.


## Where to go from here

The more formal [Cider-CI Project Specification] lists all available keys and
configuration options of Cider-CI. The [data flow] page describes the
transformations applied to the configuration file.

  [data flow]: /project-configuration/advanced/data-flow.html
  [fail-fast]: https://en.wikipedia.org/wiki/Fail-fast
  [Cider-CI Project Specification]: /project-configuration/specification/index.html

