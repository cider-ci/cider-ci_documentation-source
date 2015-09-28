---
title: Quick Start
---
{::options parse_block_html="true" /}

# Cider-CI Quick Start Guide

This is a quick start guide to Cider-CI. It takes two commands to install
a whole Cider-CI Environment. The only requirements are a _Debian 8 - Jessie_
system with at least 2GB of RAM system and a internet connection.

We recommend that the system is not accessible from the internet as it sets
a default login with a default password. Skip a few steps down to see how
to change the password after installation.

## Install

Log in as root to your Jessie system
and invoke the following two commands:

    apt-get install curl -y
    curl https://raw.githubusercontent.com/cider-ci/cider-ci_deploy/master/bin/quick-install.sh | bash

Wait until everything is finished. The duration depends on the power of our
machine and the speed of the internet connection, 30 Minutes or more are not
uncommon.

## Try It Out

0. Open the `http://IP-OF-YOUR-MACHINE` and sing in with the login `admin` and
  password `secret`.

    [![Quick Start - Sign-in](/installation/quick-start/sign-in.png){: .quick-start}](/installation/quick-start/sign-in.png)

0. You will be redirected to the [My Workspace](http://cider-ci.info/articles/my-workspace/) page. Click on `Run` of the most recent commit of the
[Cider-CI Bash Demo Project](https://github.com/cider-ci/cider-ci_demo-project-bash).

    [![Quick Start - Workspace](/installation/quick-start/workspace.png){: .quick-start}](/installation/quick-start/workspace.png)

0. Run and watch some of the provided jobs.

    [![Quick Start - Job](/installation/quick-start/job.png){: .quick-start}](/installation/quick-start/job.png)

## Change The Password

Go to _Administration_ → _Users_ → _[admin]_ and change the password. Your
session will **immediately become invalid** - this is a security feature - and
you will need to sign in again with the new password.

[![Quick Start - Change Password](/installation/quick-start/change-password.png){: .quick-start}](/installation/quick-start/change-password.png)



## Where To Go From Here

If you haven't looked at it yet: the [Introduction](/introduction/) gives
information about the entities in and the rational behind Cider-CI.

