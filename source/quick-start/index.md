---
title: Quick Start
---
{::options parse_block_html="true" /}

# Cider-CI Quick Start Guide

This is a quick start guide to Cider-CI.
It takes two commands to install a whole Cider-CI Environment
on a  _Debian 8 - Jessie_ (with at least 2GB of RAM) system.

1. Log in as root to your Jessie system
    and invoke the following two commands:

        apt-get install curl -y
        curl https://raw.githubusercontent.com/cider-ci/cider-ci_deploy/master/bin/quick-install.sh | bash

    Wait until everything is finished. How much depends on the power of our machine and
    the speed of the connection, 30 Minutes or more are not uncommon.

2. Open the `http://IP-OF-YOUR-MACHINE` and sing in with the login `admin` and
  password `secret`.

    [![Quick Start - Sign-in](/quick-start/sign-in.png){: .quick-start}](/quick-start/sign-in.png)

3. You will be redirected to the [My Workspace](http://cider-ci.info/articles/my-workspace/) page. Click on `Run` of the most recent commit of the
[Cider-CI Bash Demo Project](https://github.com/cider-ci/cider-ci_demo-project-bash).

    [![Quick Start - Workspace](/quick-start/workspace.png){: .quick-start}](/quick-start/workspace.png)

4. Run and watch some of the provided jobs.

    [![Quick Start - Job](/quick-start/job.png){: .quick-start}](/quick-start/job.png)


