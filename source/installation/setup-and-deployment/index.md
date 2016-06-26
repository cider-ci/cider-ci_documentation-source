---
title: Setup and Deployment
---
{::options parse_block_html="true" line_numbers="false" /}


# Setup and Deployment
{:.no_toc}
This page guides through the process of installing a customizable Cider-CI environment. If you are new to installing Cider-CI consider the [Quick Start Guide][].



### Table of Contents
{:.no_toc}
* Will be replaced with the ToC, excluding the "Contents" header
{:toc}


## Introduction and Prerequisites

<div class="row"> <div class="col-md-8">


A Cider-CI environment consists of **one Cider-CI server** and **any number of
Cider-CI executors**.  The technical requirements on the **executor** are
a **[Java Virtual Machine]** of version 8 or later and **[Git]** of version 2.1
or later. The **server** requires additionally **[PostgreSQL]** of version 9.4
or later. We recommend at least **4GB of memory**  and at least **two real CPU
cores** for the Cider-CI **server**. The requirements for Cider-CI executors
depends largely on what it is used for. The **Cider-CI executor process**
itself should have about **250MB of memory** available.


{: .text-warning}
It is possible to run both on the same machine but we don not recommend to do
so. A **single machine setup** is possible and can be considered for smaller
teams. Running one or even more executors on the same machine as the server can
**impact the performance** and consequently the **stability** of the
**server**.

The executors in Cider-CI act fairly autonomous. They pull work from the sever,
and then process it without further interaction from the server. One of the
benefits is that the only required connection is HTTP or preferably HTTPS from
the executors to the servers. This feature eliminates a lot of trouble within
firewall regulated environments since HTTP/HTTPS is likely possible.


  [Java Virtual Machine]: https://en.wikipedia.org/wiki/Java_virtual_machine
  [Git]: https://git-scm.com/
  [PostgreSQL]: https://www.postgresql.org/


It is feasible to install, configure and add a Cider-CI executor to an existing
Cider-CI server manually. Setting up a Cider-CI server manually would be a time
consuming and error prone challenge. We highly recommend to use the [Cider-CI
Deploy Project] to set up the server.
{: .text-warning}

The [Cider-CI Deploy Project] enables fully **automatized installation,
configuration** and **upgrading** of your environment. It supports the _Linux_
based Ubuntu 16.04 "Trusty" or Debian 8 "Jessie" operating systems out of the
box. The automated deploy requires [Ansible] of version 2.1 or later on the
[control machine]. We will discuss the set-up in the next section.

We assume that we are operating on _stock installations_ of _Debian Jessie_ or
_Ubuntu Xenial_ for the reminder of this documentation. The procedure is **well
tested** for **unmodified systems** installed from **official releases**.
{: .text-warning}

  [Ansible]: http://docs.ansible.com/ansible/index.html
  [control machine]: http://docs.ansible.com/ansible/intro_installation.html#control-machine-requirements



</div> <div class="col-md-4">

![Requirements](/installation/setup-and-deployment/server-and-executors-requirements.svg){: }

</div> </div>



## Preparing the Machines


<div class="row"> <div class="col-md-8">

Ansible is a comparatively simple deploy environment. There is no server
component but there is a machine from which the deployment is carried out. This
is called the [control machine]. If you target a single machine setup it stands
to reason to use this machine also as the Ansible control machine. We also
frequently use the Cider-CI server machine as the control machine.

In the general case the machines are distinct. During the deployment the
control machine needs to access the target machines via the ssh protocol. All
machines need access to the Internet via http(s) to download artifacts such as
packages for the system and also the packaged Cider-CI server itself.

We recommend to set up [password-less ssh access] from the control machine to
the root account of the target machines. If the deploy via Ansible seems to
hang indefinitely assert that `ssh root@your-target-machine` works without
problems.
{: .text-warning}



  [password-less ssh access]: https://linuxconfig.org/passwordless-ssh

Every controlled target machine needs a Python installation to be accessible by
Ansible. This can be easily installed for our target operating Systems _Ubuntu
Xenial_ or _Debian Jessie_ from system packages:

~~~bash
apt-get install -y python2.7
~~~

The control machine needs Ansible 2.1 or later. You can read the [Ansible
Installation] documentation how to install it for your operating system. If you
are using _Ubuntu Xenial_ you can proceed as follows:

  [Ansible Installation]: http://docs.ansible.com/ansible/intro_installation.html

~~~bash
apt-get install -y python2.7 python2.7-dev python-pip git ruby libffi-dev
pip install -I --upgrade pip
pip install -I --upgrade paramiko==1.17.0 ansible==2.1.0.0
~~~

This will install some libraries and binaries into `/usr/local`. The command
diverges from the official [Ansible Installation] documentation slightly
and circumvents some issues we encountered recently.
{: .text-warning}



</div> <div class="col-md-4">

![Ansible Requirements](/installation/setup-and-deployment/ansible-requirements.svg){: }

</div> </div>



## Setting up an Inventory

<div class="row"> <div class="col-md-6">

We will use an example environment of one _Ubuntu Xenial_ machine "xenial-16"
used as the server and one _Debian Jessie_ machine "jessie-40" as an executor.

We start out with in an new and empty directory. You can alternative start by
cloning the Git project [Cider-CI Demo-Inventory][]. We first create a `hosts`
file with the following contents. You would replace the values of
`ansible_host` with the IP or names of your machines.

</div> <div class="col-md-6">

~~~ini
# the hosts file
[cider-ci_hosts]
xenial-16 ansible_connection=ssh ansible_user=root ansible_host=192.168.0.16
jessie-40 ansible_connection=ssh ansible_user=root ansible_host=192.168.0.40

[cider-ci_server]
xenial-16

[cider-ci_executors]
jessie-40
~~~
</div> </div>


<div class="row"> <div class="col-md-6">
It is now time to connect our inventory the Cider-CI project. We clone it into
our inventory directory. If you decide to mange you inventory with Git - which
is highly recommended - you could and should mange the cider-ci folder as Git
submodule.
</div> <div class="col-md-6">
~~~bash
git clone -b release https://github.com/cider-ci/cider-ci cider-ci
cd cider-ci
git submodule update --init --recursive deploy
cd ..
~~~
</div> </div>


<div class="row"> <div class="col-md-6">
The [Cider-CI Deploy Project] comes with a set of **predefined configuration
variables**. We will it as a **base configuration**. We could copy the file
but linking it has the advantage that new configuration variables introduced with
an update of Cider-CI will be immediately available when we update the
`cider-ci` project.
</div> <div class="col-md-6">
~~~bash
mkdir group_vars
cd group_vars
ln -s ../cider-ci/deploy/all.yml all.yml
cd ..
~~~
</div> </div>

<div class="row"> <div class="col-md-6">
We will for now just override one variable the `ci_server_external_hostname`.
This one is needed so our executor `jessie-40` knows where to find its server
`xenial-40`. We create the file `group_vars/cider-ci_hosts.yml` with the
following contents.
</div> <div class="col-md-6">
~~~yaml
# the group_vars/cider-ci_hosts.yml file
ci_server_external_hostname: 192.168.0.16
~~~
</div> </div>

It is very important to use the correct file names! We are using the
[precedence rules of Ansible] here. The implicit `all.yml` group in the
inventory has a lower precedence then the explicit `cider-ci_hosts` group as
defined in our `hosts` file. If we do not use matching file names corresponding
to groups or hosts the variables defined within will not be used!
{: .text-warning}

  [precedence rules of Ansible]: http://docs.ansible.com/ansible/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable


<div class="row"> <div class="col-md-6">
Will will now set up one more and last file: `data.yml`. This one can be used
to **mange users and repositories** available in your Cider-CI instance. Both
could also be set via the user-interface. But managing them via a configuration
file is a much better solution with respect to configuration management and
documentation. Using this file also solves the chicken-and-egg problem of
needing an initial user to sign in via the user interface.

The `data.yml` files allows **templating** via Ansible respectively [Jinja2].
So `{{ci_master_secret}}` will be replaced by the actual value of
the `ci_master_secret` variable.

  [Jinja2]: http://jinja.pocoo.org/docs/dev/

</div> <div class="col-md-6">
~~~yaml
# the data.yml file

managed_users:
  admin:
    update_attributes:
      is_admin: true
      password: '{{ci_master_secret}}'

managed_repositories:
  'https://github.com/cider-ci/cider-ci_demo-project-bash':
    update_attributes:
      name: 'Cider-CI Bash Demo Project'
~~~
</div> </div>


## Running the Deploy

<div class="row"> <div class="col-md-6">
We will now perform the actual deploy. It must be started from within the [Cider-CI Deploy Project]
by supplying our inventory `hosts`  file.
</div> <div class="col-md-6">
~~~bash
cd cider-ci/deploy
ansible-playbook -i ../../hosts deploy_play.yml
~~~
</div> </div>

The deploy will take some time which largely depends on the connection speed to
the Internet.

## Signing in and Testing the Installation

<div class="row"> <div class="col-md-6">
We can now open the user interface in the browser via
`http://http://192.168.0.16` where the IP should be replaced by your IP or
hostname respectively. We will be redirected to the welcome page.

The password for the `admin` user can now be found in the `master_secret.txt`
file in our inventory directory.

</div> <div class="col-md-6">
  ![Welcome Page](/installation/setup-and-deployment/welcome-page.png){: .with-border}
</div> </div>

<div class="row"> <div class="col-md-6">

After signing in we follow the links `Administration` → `Excutors` where
we should find the configured executor up and running.

The status of the various services can be inspected by following
the links `Administration` → `Server status`.

We can finally run some job from the configured [Cider-CI Bash Demo Project]
in the same way es described in the [Quick Start Guide].

  [Cider-CI Bash Demo Project]: https://github.com/cider-ci/cider-ci_demo-project-bash

</div> <div class="col-md-6">
  ![Executors](/installation/setup-and-deployment/executors-page.png){: .with-border}
</div> </div>


  [Quick Start Guide]: /introduction/quick-start/

## Upgrading a Cider-CI Environment

<div class="row"> <div class="col-md-6">
Upgrading your Cider-CI is fairly simple once you have set up an inventory
directory. In our working example we would update the cider-ci project
and then simply rerun the deploy again.
</div> <div class="col-md-6">
~~~bash
cd cider-ci
git pull
git submodules update
cd deploy
ansible-playbook -i ../../hosts deploy_play.yml
~~~
</div> </div>

Upgrading a Cider-CI Environment is possible if the minor version (see
[Semantic Versioning][]) of Cider-CI has changed. Upgrading across major
versions is not guaranteed to be possible.
{: .text-warning}

  [Semantic Versioning]: http://semver.org/
  [Cider-CI Demo-Inventory]: https://github.com/cider-ci/demo-inventory


## Next Steps - Where to go from here

The [Cider-CI Demo-Inventory] discussed here is a good but simplistic start.
The [ZHdK Cider-CI Inventory][] uses more advanced configuration features.

  [ZHdK Cider-CI Inventory]: https://github.com/cider-ci/zhdk-inventory

