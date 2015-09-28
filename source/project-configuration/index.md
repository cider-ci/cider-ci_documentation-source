---
title: Project Configuration
---
{::options parse_block_html="true" /}

# Project Configuration

This part of the documentation is about how to configure a project to be
_tested_, _build_, _deployed_, or in fact perform any conceivable action with
Cider-CI.

Two steps must be performed to enable a project for Cider-CI:

  1. The repository must to be registered in you instance of Cider-CI, and
  2. a _Cider-CI Configuration File_ must be added to the repository.

Registering a repository is a straight forward procedure by following
`Administration` → `Repositories` → `Add a new repository` in the user
interface.

The basic structure of the configuration file is described in the [Cider-CI Configuration File]
page. More detailed information is available in the [Jobs], [Tasks], and
[Scripts][] pages. Cider-CI has several features to keep specification files
dry and maintainable. Using *contexts*, splitting the configuration over
multiple files, and the related *deep-merge* strategy are discussed in the
[Advanced Topics][] page.


If is recommended to digest the [Introduction][] before diving into this
content. Every configuration given here is demonstrated and brought in to
context in the [Cider-CI Bash Demo Project].


  [Cider-CI Bash Demo Project]: https://github.com/cider-ci/cider-ci_demo-project-bash
  [Cider-CI Configuration File]: /project-configuration/configuration-file.html
  [Jobs]: /project-configuration/jobs.html
  [Tasks]: /project-configuration/tasks.html
  [Scripts]: /project-configuration/scripts.html
  [Advanced Topics]: /project-configuration/advanced.html
  [Introduction]: /introduction/index.html

