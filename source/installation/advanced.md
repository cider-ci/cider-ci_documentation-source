# Advanced Installation
{::options parse_block_html="true" /}

### Table of Contents
{:.no_toc}
* Will be replaced with the ToC, excluding the "Contents" header
{:toc}

## Installation Options

### Admin

There needs to be at least one admin user in Cider-CI. Setting an initial admin
or resetting a password at any time later can be performed as in the following
example:

  `ansible-playbook -i hosts_demo_single play_site.yml -e 'system_admin_password=secret system_admin_login=admin'`

### User-Interface Theme

The following themes are available: `bootstrap-plain` (this is the default),
`bootstrap-theme`, `cider`, and `darkly`. Any of them can be selected as
shown in the following example:

  `ansible-playbook -i hosts_demo_single play_site.yml -e 'user_interface_theme=darkly'`

### Reseting the Master-Secret

The `cider_ci_master_secret` can be reset at any time by re-invoking
the `play_site` playbook as in the following:

  `ansible-playbook -i hosts_demo_single play_site.yml -e 'cider_ci_master_secret=REPLACE-WITH-YOUR-NEW-SECRET'`

Next to resetting all internal passwords (for the database, message queue and
internal communication) a new secret will invalidate all session cookies and
all secrets for executors to connect immediately. <span class="text-warning">
This is a security feature.</span> The user passwords itself remain valid. The
executors will be configured with new passwords during the deployment.




## Production Environment

The procedure for installing a production environment is almost the same as
for the demo environment.

However, the parameters for the example environment are far from optimal. The
[Cider-CI Deploy Project] contains the hosts file `hosts_zhkd_ci2` which is
more appropriate to be used as a template in this case. The directories
`host_vars` and `group_vars` contain further files to be used as templates and
to be customized.

The server for a production environment should have at least 4GB of memory.
A fast file system in particular with respect to [IOPS] is also recommended.
Requirements for the executors depend on the use case.

The demonstration environment installs the server and one executor on the same
machine. This is convenient but usually not a good choice for a productive
environment. There are security and reliability issues in particular with
respect to the available traits, see [Adding Traits](#adding-traits).


## Upgrading and Redeploying

Upgrading and redeploying a Cider-CI environment is similar to deploying it for
the first time. We update the master project e.g. with `git pull` and all
submodules with `git submodule update --init --recursive`.

From the `deploy` directory we execute the play_site playbook in the
same manner as before, e.g.

`ansible-playbook -i hosts_demo_single play_site.yml -e 'cider_ci_master_secret=REPLACE-WITH-YOUR-SECRET'`

We recommend to upgrade the minor versions in sequence without leaving any out,
e.g. from `3.5`, to `3.6`, and then to `3.7`. Upgrades between major versions,
e.g. from `2.4` to `3.0` may or may be not possible without complications. Please consult
the release information.

## Executor Configuration

### Initial Installation and Registration

Every executor must be registered with the server. This is performed
automatically when installing the executor via the Ansible `play_site`
playbook. To this end the executor must be registered in the Ansible hosts
file. See also the [Installation](./index.html) page.


### Root Path

The default root location of an installed executor on Linux is
`/var/local/cider-ci/executor`. The scripts are invoked as the user
`cider-ci_exec-user`.


### Adding Traits {#adding-traits}

The demo installation will provide the traits `linux` and `bash` for each
executor. They suffice to run the jobs of the [Bash Demo Project for
Cider-CI][].

#### Adding Traits Provided by the Cider-CI Deploy Project

A set of additional traits can be automatically installed with

`ansible-playbook -i hosts_demo_single play_traits.yml`

<div class="alert alert-warning" role="alert">
The traits made available are optimized for **ease of use** and **performance** but not
for isolation and security. See [Restricting the Accepted
Repositories](#accepted-repositories) for isolating executions on the basis
of the repository from each other.
</div>


#### Adding Custom Traits

Every executor advertises its available traits to the server. It aggregates the
traits from  `/etc/cider-ci/traits.txt`, and `./config/traits.txt`. The path of
the latter is meant relative to the root location of the executor. The traits
are separated by commas.

### Restricting the Accepted Repositories {#accepted-repositories}

An executor can be configured to only accept trials for certain repositories.
This is a security and trust feature. A particular executor might have the
possibility to perform deploys or commit to the repository for example. When
using this feature it can be ensured that only persons which have permission to
push to the original repository can cause actions on this executor.

The protection is twofold. The server is programmed to only dispatch accepted
repositories to an executor. The executor will at any rate refuse to process
trials for repositories it does not accept.

Defining accepted repositories is very similar to defining traits. The file
`/etc/cider-ci/accepted-repositories.txt`, and
`./config/accepted-repositories.txt` take a list of comma separated repository
URLs. In contrast to traits, if no accepted repositories are defined the
executor will accept any repository.

Heads up: the URLs must be equal by case sensitive string comparison!
{:.text .text-warning}

  [Bash Demo Project for Cider-CI]: https://github.com/cider-ci/cider-ci_demo-project-bash
  [Cider-CI Deploy Project]: https://github.com/cider-ci/cider-ci_deploy
  [IOPS]: https://de.wikipedia.org/wiki/Input/Output_operations_Per_Second
