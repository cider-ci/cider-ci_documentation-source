---
title: Easy Setup and Deploy
---
{::options parse_block_html="true" /}

# Setup and Deploy
{:.no_toc}
This page guides through the process of installing a simple Cider-CI
environment.

This guide is optimized for easiness and providing quick results. After
providing the prerequisites it will just take **3 easy steps** and about
**three minutes** your time to kick off the installation process.


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
install a Cider-CI executor manually on other operating systems.

The remainder of this page focuses on a **simple** setup existing of one
**single machine**. Advanced installation and installing to Windows is out of
the scope of this page but covered in other documents of this documentation.


## Prerequisites and Preparation

<div class="row"> <div class="col-md-6">

The [Cider-CI Deploy Project] relies heavily on Ansible which must must be
present on the *control* machine. See the [Install][] page of the Ansible
Documentation. We use a fairly recent version (≥ 1.9 at the time of writing) of
Ansible. The operating system on the controller is not relevant. We use _Mac OS
X_ and various _Linux_ variants.

The working account on the **control machine** must have **ssh access to all
target machines**. A setup with SSH keys and without passwords to the root
account is the most straight forward configuration.


</div> <div class="col-md-6">

[![Environment](/installation/simple-demo.svg)](/installation/simple-demo.svg)

</div> </div>

<div class="alert alert-info" role="info">
Accessing machines directly via the root account is now discouraged in many and
effectively disabled in some Linux distributions. Read [How to enable ssh root
access on Ubuntu 14.04][] for example.
</div>




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
