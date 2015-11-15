---
title: Quick Start
---
{::options parse_block_html="true" /}

# Cider-CI Quick Start Guide

This is a quick start guide to Cider-CI. It takes two commands to install
a whole Cider-CI Environment. The only requirements are a _Debian 8 - Jessie_
system with at least 2GB of RAM system and a Internet connection.

We recommend that the system is not accessible from the Internet as it sets
a default login with a default password. Skip a few steps down to see how
to change the password after introduction.

## Install

Log in as root to your Jessie system
and invoke the following two commands:

    apt-get update && apt-get install curl -y
    curl https://raw.githubusercontent.com/cider-ci/cider-ci_deploy/master/bin/quick-install.sh | bash

Wait until everything is finished. The duration depends on the power of our
machine and the speed of the Internet connection, 30 Minutes or more are not
uncommon.

<div class="alert alert-warning">
  The install may abort due to temporary problems with downloads. In that case
  just run it again.
</div>


## Try It Out

0. Open the `http://IP-OF-YOUR-MACHINE` and sing in with the login `admin` and
  password `secret`.

    [![Quick Start - Sign-in](/introduction/quick-start/sign-in.png){: .quick-start}](/introduction/quick-start/sign-in.png)

0. You will be redirected to the [My Workspace](http://cider-ci.info/articles/my-workspace/) page. Click on `Run` of the most recent commit of the
[Cider-CI Bash Demo Project](https://github.com/cider-ci/cider-ci_demo-project-bash).

    [![Quick Start - Workspace](/introduction/quick-start/workspace.png){: .quick-start}](/introduction/quick-start/workspace.png)

0. Run and watch some of the provided jobs.

    [![Quick Start - Job](/introduction/quick-start/job.png){: .quick-start}](/introduction/quick-start/job.png)

## Change The Password

Go to _Administration_ → _Users_ → _[admin]_ and change the password. Your
session will **immediately become invalid** - this is a security feature - and
you will need to sign in again with the new password.

[![Quick Start - Change Password](/introduction/quick-start/change-password.png){: .quick-start}](/introduction/quick-start/change-password.png)



## Where To Go From Here

If you haven't looked at it yet: the [Introduction](/introduction/) gives
information about the entities in, and the rational behind Cider-CI.

If you want to configure your project to be tested with Cider-CI read
the [Project Configuration](/project-configuration/) guide.

If you want to customize you installation read the [Setup and Deploy][] guide.

  [Setup and Deploy]: /installation/setup-and-deploy/index.html



