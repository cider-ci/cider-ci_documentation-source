---
title: Easy Setup and Deploy
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
gets very simple if this machine also acts as the control machine. More about
that in the next section.


## Prerequisites and Preparation

<div class="row"> <div class="col-md-6">

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

**Make sure that all of the depicted connections are possible and actually work
in your environment.**


  [WinRM]: https://msdn.microsoft.com/en-us/library/aa384426(v=vs.85).aspx
  [Windows Support]: http://docs.ansible.com/ansible/intro_windows.html
  [two Ansible related lines of the quick-install script]: https://github.com/cider-ci/cider-ci_deploy/blob/master/bin/quick-install.sh#L37-L38
  [quick-install script]: https://github.com/cider-ci/cider-ci_deploy/blob/master/bin/quick-install.sh


</div> <div class="col-md-6">


~~~
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

</div> </div>


## Step by Step Instructions

The following example assumes that a single Linux machine
is ready installed, we call it the `demo-machine`.


1.  We check out the [Cider-CI Main Project][] including all sub-projects inside
    the control machine:

    `git clone --recursive https://github.com/cider-ci/cider-ci.git`

2. We descend into the deploy directory which is part of the [Cider-CI Deploy Project][]:

    `cd cider-ci/deploy`

3. We start the setup with the following command where we replace
    `192.168.0.31` with the IP address of our `demo-machine`:


    ```DEPLOY_ROOT_DIR=`pwd` ansible-playbook -i inventories/demo/easy/hosts play_site.yml -e 'ansible_ssh_host=192.168.0.31 cider_ci_master_secret=secret admin_password=secret'```

    <div class="alert alert-warning" role="alert">
    You can leave the value of the `cider_ci_master_secret` and `admin_password`
    as is if your `demo-machine` cannot be accessed from "the outside". Otherwise
    you need to change them or virtually everbody has unrestricted access to
    your machine!
    </div>

<div class="alert alert-info" role="info">
Installing Cider-CI from scratch can take a while. 45 minutes are typical for
a virtual machine running on my laptop. The setup performs many downloads from
the internet which can be a reason for temporary failures. The playbook is
idempotent and thus can be rerun again at any time.
</div>


This is it. You can no visit your installation at
`http://IP-OF-YOUR-DEMO-MACHINE`. The setup will create an `admin` user with
the password `secret` (unless the parameters have been changed in step 3). The
setup also configured two projects. Run some of the jobs from the [Cider-CI
Bash Demo Project][] to learn about the capablities of Cider-CI.




## Next

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
