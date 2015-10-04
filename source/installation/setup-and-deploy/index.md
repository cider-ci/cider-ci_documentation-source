---
title: Setup and Deployment
---
{::options parse_block_html="true" line_numbers="false" /}

# Setup and Deploy
{:.no_toc}
This page guides through the process of installing a Cider-CI environment.


### Table of Contents
{:.no_toc}
* Will be replaced with the ToC, excluding the "Contents" header
{:toc}


## Introduction

Installing and maintaining a Cider-CI environment is largely an automated
process thanks to the [Cider-CI Deploy Project][]. It supports any mixture of
the _Linux_ based Ubuntu 14.04 "Trusty" or Debian 8 "Jessie" operating systems
for the Cider-CI server and executors. Since Cider-CI version 3.7 "Redmond"
executors running on _Windows_ are supported, too. It is also possible to
install a Cider-CI executor manually.

A working Cider-CI environment includes **exactly one _Cider-CI server_** and
virtually **any number of _Cider-CI executors_**. In most most environments
every component runs in its own machine. It is possible to run the server and
one executor within the same machine. But we generally recommend against doing
so.

However a single machine environment can make sense for light use cases, e.g.
when a single developer wants occasionally to run tests. A single machine setup
is also easier to set-up and less demanding when it comes to interaction of the
machines with respect to network configuration and firewalls in particular. It
gets very simple if this machine also acts as the _control machine_. The
control machine is purely used for deployment. It does not play a role when
the Cider-CI environment is performing its daily business.

## Example Environments


<div class="row"> <div class="col-md-6">

We will use two exemplary environments for illustration. There is the
**_simple_ demo environment**. One single Linux machine hosts the server,
executor and also the control machine. We choose one of the two examples as
a template when we will actually configure and deploy our environment. We
recommend to use the simple example when installing Cider-CI for the first
time.

The **_advanced_ demo environment** consists of a server, an executor running
on Linux, an executor running on Windows, and a control machine. You can still
go with the advanced example even if you don't plan to use windows. We will
remove the windows host from the configuration in this case later on.


~~~
  "Simple" Demo Environment: 1 Machine, only local connections
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

       ╔════════════════════════════════════════════════╗
       ║                                                ║
       ║                Control Machine                 ║
       ║                                                ║
       ║                Cider-CI Server                 ║
       ║                                                ║
       ║            Cider-CI Linux Executor             ║
       ║                                                ║
       ╚════════════════════════════════════════════════╝
~~~

</div> <div class="col-md-6">

~~~
  "Advanced" Demo Environment: 3 CI Machines + Control Machine
 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

 ┏━━━━━━━━━━━━━━━━━━┓              ╔═══════════════════════════╗
 ┃                  ┃              ║                           ║
 ┃                  ┣──────SSH─────▶  Cider-CI Linux Executor  ║
 ┃                  ┃              ║                           ║
 ┃                  ┃              ╚══▲═══════════════════╦════╝
 ┃                  ┃                 │                   │
 ┃                  ┃                 │                   │
 ┃                  ┃              HTTPS                HTTPS
 ┃                  ┃              (push)           (ping, sync,
 ┃                  ┃                 │             config, pull)
 ┃                  ┃                 │                   │
 ┃                  ┃              ╔══╩═══════════════════▼════╗
 ┃                  ┃              ║                           ║
 ┃ Control Machine  ┃              ║                           ║
 ┃                  ┣──────SSH─────▶      Cider-CI Server      ║
 ┃      Ansible     ┃              ║                           ║
 ┃                  ┃              ║                           ║
 ┃                  ┃              ╚══╦═══════════════════▲════╝
 ┃                  ┃                 │                   │
 ┃                  ┃                 │                   │
 ┃                  ┃              HTTPS                HTTPS
 ┃                  ┃              (push)            (ping, sync,
 ┃                  ┃                 │             config, pull)
 ┃                  ┃                 │                   │
 ┃                  ┃              ╔══▼═══════════════════╩════╗
 ┃                  ┃              ║                           ║
 ┃                  ┣────WinRM─────▶ Cider-CI Windows Executor ║
 ┃                  ┃              ║                           ║
 ┗━━━━━━━━━━━━━━━━━━┛              ╚═══════════════════════════╝
~~~



</div></div>



## Prerequisites and Preparation


The [Cider-CI Deploy Project] relies heavily on Ansible which must be present
on the *control* machine. The control machine orchestrates deployment and
updates.

See the [Install][] page of the Ansible Documentation to install Ansible.
Alternatively you might want to have look at the [two Ansible related lines of
the quick-install script][] to quickly install Ansible without hassle. We use
a fairly recent version (≥ 1.9 at the time of writing) of Ansible. The
operating system on the controller is not relevant. We use *Mac OS X* and
various *Linux* variants.

It is possible to run use a machine which is part of the Cider-CI environment
as a control machine (as long it is not a Windows machine). The simplest
Cider-CI environment combines the server, executor and control machine in one
single instance. This is actually what happens when you follow the [Quick
Start] guide which is essentially performed by the already mentioned
[quick-install script].

Preparing the Linux machines is little effort. The working account on the
**control machine** must have **ssh access to all Linux target machines**.
A setup with SSH keys and without passwords to the root account is the most
straight forward configuration.

A Windows system needs more manual preparation. Read the [Windows Preparation]
guide for more information if you are going to deploy one or more executors on
Windows.

Every executor needs during installation and for operation access via HTTPS to
the server. The server dispatches via HTTPS during normal operation. There is
also a *pull mode only*. See the [Pull Mode Howto][].

**Make sure that all of the depicted connections are possible and actually do
work in your environment.**

### List of Required Software on the Control Machine

  * Ansible
  * Git
  * OpenSSL

## Project Checkout - Cloning
We login to our control machine and clone the complete Cider-CI project
including all submodules. The `master` branch contains the most recent stable
version and is usually a good choice.

`git clone -b master https://github.com/cider-ci/cider-ci.git --recursive`

We descend into the deploy directory/project.

`cd cider-ci/deploy`

## Setting Up an Inventory
{: #inventory}

<div class="row"> <div class="col-md-6">

There is an inventory directory which contains two demo environments. See the
tree structure in the provided code snippet.

The main inventory files are [`inventories/demo/simple/hosts`] and
[`inventories/demo/advanced/hosts`] respectively. They define the machines (or
hosts) as the name of the file suggests. The other files are group or machine
related configuration files. We **copy either of the two inventories** to
a place outside the repository.

`cp -rv inventories/demo/simple PATH-TO-OUR-INVENTORY`

or

`cp -rv inventories/demo/advanced PATH-TO-OUR-INVENTORY`

We will modify our freshly created inventory in the next sections. The contents
of the deploy folder remain untouched.


</div> <div class="col-md-6">

    ▾ inventories/
      ▾ demo/
        ▾ advanced/
          ▾ group_vars/
              cider-ci-executors-linux.yml
              secrets.yml
          ▾ host_vars/
              windows-executor.yml
            hosts
        ▾ simple/
          ▾ host_vars/
              demo-machine.yml
            hosts

</div></div>

<div class="alert alert-info">
It was recommended to fork the [Cider-CI Deploy Project] in earlier revisions
of this guide to perform changes within. The structure of the project has been
rewritten as of version 3.7.
</div>


### Adjusting the Hosts File

<div class="row"> <div class="col-md-6">
The `hosts` file of the inventory declare the involved machines and groups
them. It can also contain host specific variables but it is recommended
to keep those in a host specific file located in the `host_vars` directory
relative to the `hosts` file. See the directory structure of the previous
section for an example.

The simple demo uses the local connection `127.0.0.1`.  We don't need to change
anything in this case.
</div> <div class="col-md-6">
    # Cider-CI hosts for the simple demo

    [simple-demo-machines]
    demo-machine ansible_ssh_host=127.0.0.1 ansible_ssh_user=root

    [cider-ci-server]
    demo-machine

    [cider-ci-executors-linux]
    demo-machine
</div></div>

<div class="row"> <div class="col-md-6">

We need tho **adjust the IP addresses** for the advanced demo . We **either
delete the `windows-executor`** and all references in the file or we **adjust
the IP address** and the **connection parameters** for it. See the
[Windows Preparation Guide] and in particular the [inventory] section.


</div> <div class="col-md-6">
    # Cider-CI hosts for the advanced demo

    [advanced-demo-machines]
    server ansible_ssh_host=192.168.0.10 ansible_ssh_user=root
    linux-executor ansible_ssh_host=192.168.0.11 ansible_ssh_user=root
    windows-executor ansible_ssh_host=192.168.0.60

    [cider-ci-server]
    server

    [cider-ci-executors-linux]
    linux-executor

    [cider-ci-executors-windows]
    windows-executor
</div></div>


### The Master-Secret

<div class="row"> <div class="col-md-6">
Every Cider-CI Environment contains several secrets, there is for example one
for the database, one for signing session objects and so on. By default all
these secrets are build from one master-secret, but each of them can defined
individually, but there is usually no need to do so.

The master-secret has a default value which is likely to be secure but that
depends on how the server machine is configured and on who can access what data
inside of it. We highly recommend to override the master-secret.

Uncomment and adjust the value of the `cider_ci_master_secret` in
`group_vars/demo-machines.yml`.
</div> <div class="col-md-6">
    # in group_vars/demo-machines.yml
    cider_ci_master_secret: A-VERY-LONG-SECRET-STRING
</div></div>


### Setting Custom Variables

The `cider_ci_master_secret` is one example of many variables which have default
values but can be overridden. These variables are defined in the file
[group_vars/all.yml][] (relative to the top level deploy project). We recommend
to have a look into the file to see what variables are available. The secrets
section towards the end is in particular relevant with respect to redefining
the `cider_ci_master_secret`.

#### Rules of Precedence

The following explains slightly simplified rules for variable precedence. The
precise rules are explained in the [Variable Precedence Documentation of
Ansible][]. The [group\_vars/all.yml][] file in the [Cider-CI Deploy Project]
is the first one consulted for variable definitions. Then come the `group_vars`
in the individual inventory (relative to the `hosts` file), then the
`host_vars`. Finally command line options for `ansible` or `ansible-playbook`
will override any variable which were set before. We will make use of this when
performing a deploy in the next section.

  [group\_vars/all.yml]: https://github.com/cider-ci/cider-ci_deploy/blob/master/group_vars/all.yml
  [Variable Precedence Documentation of Ansible]: http://docs.ansible.com/ansible/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable


## Deploy
{: #deploy}

We will now deploy our configured Cider-CI environment:

```ANSIBLE_LOAD_CALLBACK_PLUGINS=1 DEPLOY_ROOT_DIR=`pwd` ansible-playbook -i PATH-TO-OUR-INVENTORY play_site.yml -e "admin_password=SOME-SECRET"```

The deploy can take a while. We can expect at least 30 minutes for an initial
deploy. It can take much longer depending on the power of the machines and
moreover the on the speed of the Internet connection.

The deploy depends on a lot of downloads from the Internet. If one download
fails the deploy will abort. It is possible to invoke the command at any time
later again.


## Where to go from here

Add your own project to your installation and configure it which is covered in
[Project Configuration](/project-configuration/). You will probably need a few
more traits on top of the default ones. Read about adding traits to your
executor in [Adding Traits](/installation/adding-traits). If you want learn about how
to set up an production like Cider-CI environment read [Advanced
Installation]().


  [Cider-CI Bash Demo Project]: https://github.com/cider-ci/cider-ci_demo-project-bash.git
  [Cider-CI Deploy Project]: https://github.com/cider-ci/cider-ci_deploy
  [Cider-CI Main Project]: https://github.com/cider-ci/cider-ci
  [How to enable ssh root access on Ubuntu 14.04]: http://askubuntu.com/questions/469143/how-to-enable-ssh-root-access-on-ubuntu-14-04
  [Install]: http://docs.ansible.com/intro_installation.html
  [Windows Preparation]: /installation/setup-and-deploy/windows-preparation
  [`inventories/demo/advanced/hosts`]: https://github.com/cider-ci/cider-ci_deploy/blob/master/inventories/demo/advanced/hosts
  [`inventories/demo/simple/hosts`]: https://github.com/cider-ci/cider-ci_deploy/blob/master/inventories/demo/simple/hosts
  [group_vars/all.yml]: https://github.com/cider-ci/cider-ci_deploy/blob/master/group_vars/all.yml
  [quick-install script]: https://github.com/cider-ci/cider-ci_deploy/blob/master/bin/quick-install.sh
  [two Ansible related lines of the quick-install script]: https://github.com/cider-ci/cider-ci_deploy/blob/master/bin/quick-install.sh#L37-L38
  [Pull Mode Howto]: /howtos/executors/pull-mode/index.html
  [Windows Preparation Guide]: ./windows-preparation/index.html
  [inventory]: ./windows-preparation/index.html#inventory



