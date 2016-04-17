---
title: Adding Traits - Advanced Installation
---
{::options parse_block_html="true" /}

<div class="alert alert-danger">
  TODO: This part of the documentation is partly outdated and needs to be
  updated for Cider-CI 4.
</div>

# Adding Traits {#adding-traits}

The demo installation will provide the traits `linux` and `bash`, respectively
`windows`, and `powershell`, and `fsharp` for each executor. They suffice to
run the jobs of the [Cider-CI Bash Demo Project][] respectively
the [Cider-CI Windows Demo Project].

## Adding Traits Provided by the Cider-CI Deploy Project

The [Cider-CI Deploy Project] includes a number of traits, listed in
TODO which can be installed on demand. The
ones mentioned above are enabled by default, all others are "opt in" by setting
the corresponding value to `True`. This is demonstrated in
`TODO` for
example.


## Adding Custom Traits

### Step by Step Example

Let us assume that we need to tool `wget`. So we have added a trait called
`wget` to our project specification, see the page [Tasks in Project
Configuration][]. The job has been launched and a corresponding trial will not
get dispatched because the Cider-CI Server can not find a suitable executor.
`wget` is provided on Debian and derivatives. We install it via `apt-get
install wget`. It might have been already installed but that is not the point
here. At this time the neither the Cider-CI Server nor the Cider-CI Executor
know about this fact. We add the line `- wget` to the file
`/var/local/cider-ci/config/traits.yml`. A fews seconds later the trait will be
shown e.g. in `Administration` → `Executors` → `Show more` and the trail will
be dispatched.

### Inner Workings

Every executor advertises its available traits to the server. It aggregates the
traits from  `/var/local/cider-ci/config/traits.yml`, and
`/var/local/cider-ci/executor/config/traits.yml` on Linux, respectively from
`C:\cider-ci\config\traits.yml`, and `C:\cider-ci\config\executor\traits.yml`
on Windows. The latter file should be reserved for manipulation by the
[Cider-CI Deploy Project], the first location is meant to be used for traits
which are manged by other means.


  [Cider-CI Bash Demo Project]: https://github.com/cider-ci/cider-ci_demo-project-bash.git
  [Cider-CI Windows Demo Project]: https://github.com/cider-ci/cider-ci_demo-project-windows
  [`play_traits_executors-linux.yml`]: https://github.com/cider-ci/cider-ci_deploy/blob/tmp/play_traits_executors-linux.yml
  [Tasks in Project Configuration]: /project-configuration/specification/task.html

