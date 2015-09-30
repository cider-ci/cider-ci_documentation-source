---
title: Setup and Deployment
---
{::options parse_block_html="true" /}

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
for the Cider-CI Server and executors. Since Cider-CI version 3.7 "Redmond"
executors running on _Windows_ are supported, too. It is also possible to
install a Cider-CI executor manually on other operating systems currently not
supported for automatic setup, e.g. "Mac OS X".

A working Cider-CI environment includes **exactly one _Cider-CI Server_** and
virtually **any number of _Cider-CI Executors_**. In most most environments
every component runs in its own machine. It is possible to run the server and
one executor within the same machine. We **recommend against running an
executor in the same machine as the server** in **larger environments** and in
particular when the working efficiency of **several users** depends on the
system, which is often the case.

However a single machine environment can make sense for light use cases, e.g.
when a sigle developer wants occasionally to run tests. A single machine setup
is also easier to set-up and less demanding when it comes to interaction of the
machines with respect to network configuration and firewalls in particular. It
gets very simple if this machine also acts as the _control machine_. The
control machine is purely used for deployment. It doesn't play a role when
the Cider-CI environment is performing its daily business.

## Example Environments


<div class="row"> <div class="col-md-6">

We will use two exemplary environments for illustration. There is the **_simple_
demo environment**. One single Linux machine hosts the server, executor and also the
control machine.

The **_advanced_ demo environment** consists of a server, an executor running on Linux,
an executor running on Windows, and a control machine.

We choose one of the two examples as a template when we will actually configure
and deploy our environment. We recommend to use the simple example when
installing Cider-CI for the first time.

You can still go with the advanced example even if you don't plan to use
windows. We will remove the windows host from the configuration in this
case later on.

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
the quick-install script][] to quickly install Ansbile without hassle. We use
a fairly recent version (≥ 1.9 at the time of writing) of Ansible. The
operating system on the controller is not relevant. We use *Mac OS X* and
various *Linux* variants.

It is possible to run use a machine which is part of the Cider-CI environment
as a control machine (as long it is not a Windows machine). The simplest
Cider-CI environment combines the server, executor and control machine in one
single instance. This is actually what happens when you follow the [Quick
Start] guide which is essentially performed by the already mentioned
[quick-install script].


The working account on the **control machine** must have **ssh access to all
Linux target machines**. A setup with SSH keys and without passwords to the
root account is the most straight forward configuration.

It must have also access via [WinRM][] to **all Windows executors**. There is
also some extra setup to be performed on the control machine in this case.
Please read and follow the instructions on the [Windows Support][] page of the
Ansible documentation.

Every executor needs during installation and for operation access via HTTPS to
the server. The server dispatches via HTTPS during normal operation. There is
also a pull only mode. More to this later.

**Make sure that all of the depicted connections are possible and actually do
work in your environment.**


  [WinRM]: https://msdn.microsoft.com/en-us/library/aa384426(v=vs.85).aspx
  [Windows Support]: http://docs.ansible.com/ansible/intro_windows.html
  [two Ansible related lines of the quick-install script]: https://github.com/cider-ci/cider-ci_deploy/blob/master/bin/quick-install.sh#L37-L38
  [quick-install script]: https://github.com/cider-ci/cider-ci_deploy/blob/master/bin/quick-install.sh

## Project Checkout and Inventory Setup

### Cloning
We login to our control machine and clone the complete Cider-CI project
including all submodules. The `master` branch contains the most recent stable
version and is usually a good choice.

`git clone -b master https://github.com/cider-ci/cider-ci.git --recursive`

We descend into the deploy directory/project.

`cd cider-ci/deploy`

### Inventory

<div class="row"> <div class="col-md-6">

There is an inventory directory which contains two demo environments. See the
tree structure in the provided code snippet.

The main inventory files are [`inventories/demo/simple/hosts`] and
[`inventories/demo/advanced/hosts`] respectively. They define the machines (or
hosts) as the name of the file suggests. The other files are group or machine
related configuration files. We **copy either of the two inventories** to
a place outside the repository.

`cp -rv inventories/demo/simple PATH-TO-MY-INVENTORY`

or

`cp -rv inventories/demo/advanced PATH-TO-MY-INVENTORY`

  [`inventories/demo/simple/hosts`]: https://github.com/cider-ci/cider-ci_deploy/blob/master/inventories/demo/simple/hosts
  [`inventories/demo/advanced/hosts`]: https://github.com/cider-ci/cider-ci_deploy/blob/master/inventories/demo/advanced/hosts



<div class="alert alert-info">
It was recommended to fork the [Cider-CI Deploy] project in the past and
perform changes within. The structure of the project has been rewritten as of
version 3.7. It should now suffice to make adjustments within a dedicated
inventory.
</div>

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

### Hosts Files

<div class="row"> <div class="col-md-6">
The `hosts` files declare the involved machines, group then, and define  how
they can be reached for Ansible during deployment.

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

For the advanced demo we need tho **adjust the IP addresses**.

We **either delete the `windows-executor`** and all references in
the file or we **adjust the IP address** and the **connection parameters**
for it.

</div> <div class="col-md-6">
    # Cider-CI hosts for the advanced demo

    [advanced-demo-machines]
    server ansible_ssh_host=192.168.0.10 ansible_ssh_user=root
    linux-executor ansible_ssh_host=192.168.0.11 ansible_ssh_user=root
    windows-executor ansible_ssh_host=192.168.0.60 ansible_connection=winrm ansible_ssh_user=root ansible_ssh_pass=root

    [cider-ci-server]
    server

    [cider-ci-executors-linux]
    linux-executor

    [cider-ci-executors-windows]
    windows-executor
</div></div>


<div class="row"> <div class="col-md-6">
In case when we kept the Windows executor: the deploy procedure will
create a user on the windows system, we should change
the `win_executor_user_password` in `host_vars/windows-executor.yml`.
</div> <div class="col-md-6">
    # Configuration for the windows-executor in the advanced demo
    win_executor_user_password: SECRET
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

The `cider_ci_master_secret` is one example of many variables wich have default
values but can be overridden. These variables are defined in the file
[group_vars/all.yml][] (relative to the top level deploy project). We recommend
to have a look into the file to see what variables are available. The secrets
section towards the end is in particular relevant with respect to redefining
the `cider_ci_master_secret`.

The following explains slightly simplified rules for variable precedence.
The precise rules are explained in [...] but there should be no need to
dive that deep into the matter unless we run into problems.

This `all.yml` file is the first one consulted for variable definitions. Then
comme the `group_vars` in the individual inventory (relative to the `hosts`
file), then the `host_vars`. Finally command line options for `ansible` or
`ansible-playbook` will override any variable which were set before. We will
make use of this when actually performing a deploy in the next section.


  [group_vars/all.yml]: https://github.com/cider-ci/cider-ci_deploy/blob/master/group_vars/all.yml


## Where to go from here

Add your own project to your installation and configure it which is covered in
[Project Configuration](/project-configuration/). You will probably need a few
more traits on top of the default ones. Read about adding traits to your
executor in [Adding Traits](./adding-traits.html). If you want learn about how
to set up an production like Cider-CI environment read [Advanced
Installation]().



  [Cider-CI Bash Demo Project]: https://github.com/cider-ci/cider-ci_demo-project-bash.git
  [Cider-CI Deploy Project]: https://github.com/cider-ci/cider-ci_deploy
  [Cider-CI Main Project]: https://github.com/cider-ci/cider-ci
  [How to enable ssh root access on Ubuntu 14.04]: http://askubuntu.com/questions/469143/how-to-enable-ssh-root-access-on-ubuntu-14-04
  [Install]: http://docs.ansible.com/intro_installation.html
