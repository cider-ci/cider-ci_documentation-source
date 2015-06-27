---
title: Project Configuration
---
{::options parse_block_html="true" /}

# Project Configuration

This part of the documentation is about how to configure a project to be
_tested_, _build_, _deployed_, or in fact perform any conceivable action with
Cider-CI.

If is recommended to digest the [Introduction][] before diving into this
content. Every configuration given here is demonstrated and brought in to
context in the [Bash Demo Project for Cider-CI][].

There can be configuration directives in the [Bash Demo Project for Cider-CI]
which are not covered in this documentation. Those are considered unstable and
can be changed or even removed  in future releases of Cider-CI without
warranting an increment of the major version number of Cider-CI.
{: .text .text-warning}

Configuring a project for Cider-CI starts with creating a `.cider-ci.yml`
dotfile. The basic structure of the dotfile is described in the [Dotfile][]
page. More detailed information is available in the [Jobs][], [Tasks][], and
[Scripts][] pages.

Cider-CI has several features to keep specification files dry and maintainable.
Using *contexts*, splitting the configuration over multiple files, and the
related *deep-merge* strategy are discussed in the [Advanced Topics][] page.


  [Bash Demo Project for Cider-CI]: https://github.com/cider-ci/cider-ci_demo-project-bash
  [Dotfile]: /project-configuration/dotfile.html
  [Jobs]: /project-configuration/jobs.html
  [Tasks]: /project-configuration/tasks.html
  [Scripts]: /project-configuration/scripts.html
  [Advanced Topics]: /project-configuration/advanced.html
  [Introduction]: /introduction/index.html

