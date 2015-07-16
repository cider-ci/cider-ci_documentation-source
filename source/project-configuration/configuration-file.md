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


## The Configuration File - Getting Started
{: #getting-started}

The following example shows a simple but fully functional Cider-CI
configuration file. It specifies one job with one task and inside a very simple
script. The screenshot shows a corresponding outcome in Cider-CI when after the
specified job has been run.

<div class="row"> <div class="col-md-6">

    jobs:

      intro-demo:
        name: Introduction Demo and Example

        context:

          tasks:

            example-task:
              name: Example Task

              traits:
                linux: true
                bash: true

              scripts:

                equality:
                  name: Equality Test

                  body: |
                    #!/usr/bin/env bash
                    test a = a
  {: .language-yaml}

</div> <div class="col-md-6">
[![Intro](/project-configuration/intro-job.png){: .docu-image}](/project-configuration/intro-job.png)
</div> </div>

## Maps and Arrays

The omnipresence of maps and the absence of arrays in the configuration file is apparent.
Maps are generally favored in Cider-CI because they enable inclusion. This is
discussed in the [Advanced Topics] page. The above example is
actually included from the configuration file of the
[Bash Demo Project for Cider-CI]
which is similar to
the following example.


    _cider-ci_include:
      - .cider-ci/jobs/attachments.yml
      - .cider-ci/jobs/introduction.yml
      - .cider-ci/jobs/timeout.yml
  {: .language-yaml}



  [Advanced Topics]: /project-configuration/advanced.html
  [Bash Demo Project for Cider-CI]: https://github.com/cider-ci/cider-ci_demo-project-bash

