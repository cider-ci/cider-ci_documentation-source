---
title: Preparing a Windows Executor
---
{::options parse_block_html="true" line_numbers="false" /}

# Preparing a Windows Executor
{:.no_toc}
This page guides through the process of installing a Cider-CI environment.


### Table of Contents
{:.no_toc}
* Will be replaced with the ToC, excluding the "Contents" header
{:toc}


## Introduction

Cider-CI supports executors on Windows systems as of version 3.7 "Redmond".
Automatizing configuration of a Windows system has become practical with
_Powershell Remoting_. This is what Ansible is using under the hood.

Setting up _Powershell Remoting_ is however nowhere as quick as preparing
a Linux system. The effective lack of a standard software repository for the
operating system adds to the time necessary to prepare the system.

{: .text-warning}
We do not recommend to set up a Windows machine unless you are fairly sure that
you really need one. You can expect that the setup of the Windows machine alone
will take more time as configuring all the rest of a Cider-CI environment.

You can take this as a good sing of how easy the rest of Cider-CI to set up.
Also, if you have performed the initial setup for Windows you are done with
respect to Cider-CI. Installation and future upgrades[^1] are fully
automatized.

## Prerequisites

Cider-CI supports currently only 64 bit versions of Windows. We are testing with
a "Windows Server 2008", and a new "Windows 10" instance. We expect that
anything in between will work, too.

{: .text-warning}
The firewall of the system must be set so that the protocols mentioned in the
[Setup and Deploy Guide](..) are not impaired. Windows systems come with a set
of so called _Group Policies_. Some settings can interfere with the proper
working of a Cider-CI executor. Larger organizations often modify and enforced
customized _Group Policies_ in their environment.



## Configuring the Windows Machine and the Control Machine for Ansible

The control machine must have access via [Windows Powershell Remoting][] to **all Windows
executors**. Read and follow the instructions on the [Windows Support][]
page of the Ansible documentation.

## Required Additional Software for Cider-CI

A Cider-CI executor on Windows requires the following extra software
to be installed on the machine.

1.  A Java JDK of version 7 or later.

2.  A recent version of Git. Make sure that the git executable is added to the
    path during install.

3.  The _F#_ programming language. More precisely: make sure that the following
  path `C:\Program Files (x86)\Microsoft SDKs\F#\4.0\Framework\v4.0\Fsi.exe` is
  working properly.

All of the mentioned software should preferably installed for all users of the
system. Precise rules for finer granulated configuration can be deduced from
the following section.


## Users and Access

The deploy script requires a local user which is in the _Windows Administrators
Group_. The account name and password must be defined in your inventory
configuration[^deploy-account]. This user will only be used during deploys and upgrades. The
default settings should bring all required permissions to operate properly.
<span class="text-warning"> Check your possibly customized _Group Policies_ if
there are problems during deploy. </span>

The deploy process will create (if not already present) a second user with the
account name `cider-ci_executor`. The Cider-CI executor service will run under
this account and scripts under normal operation will be executed as this user
too. <span class="text-warning"> This is different to how a Linux executor will
work in default mode where there is a separation between service and execution
user. </span> The reason for proceeding in this way on Windows is related to so
called [Shatter attacks](https://en.wikipedia.org/wiki/Shatter_attack).

The deploy process will add `cider-ci_executor` to the _Users_ group but not to
any other group, e.g. _Administrators_. The password of the this user must be
configured in your inventory and it may not be changed after the deploy.

## The Inventory
{: #inventory}

<div class="row"> <div class="col-md-6">

We keep the host specific parameters in a separate file in the directory
`host_vars` relative to the `hosts` file. The file name must match to name of
the machine in the `hosts` file which is `windows-executor` respectively
`windows-executor.yml` in our case. See also the [inventory section][] in the
general [Setup and Deploy Guide][]

The `ansible_ssh...` named variables for the windows executor are misnomers
introduced by Ansible for obscure reasons. There is nothing going on via the
`SSH` protocol, the `WinRM` protocol is effectively used all the time.
{: .text-warning}

  [inventory section]: ../index.html#inventory
  [Setup and Deploy Guide]: ../index.html
</div> <div class="col-md-6">

~~~ yaml
# Configuration for the windows-executor in the advanced demo

ansible_connection: winrm

# login for the local administrator account, TO BE ADJUSTED
ansible_ssh_user: root
# password for the local administrator account, TO BE REPLACED
ansible_ssh_pass: root

# password for the execution user, TO BE REPLACED
win_executor_user_password: secret

# enabled for pull mode only
executor_base_url: NULL
~~~

</div></div>


  [^1]: As long as Cider-CI does not get a larger upgrade which requires a
    higher version of Java for instance. Things like this happen very rarely.



  [Windows Powershell Remoting]: https://msdn.microsoft.com/en-us/library/aa384426(v=vs.85).aspx
  [Windows Support]: http://docs.ansible.com/ansible/intro_windows.html



