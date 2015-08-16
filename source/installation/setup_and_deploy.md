---
title: Setup and Deploy - Installation
---
{::options parse_block_html="true" /}

# Setup and Deploy - Installing Cider-CI
{:.no_toc}
This page guides through the process of initially installing a Cider-CI environment.


### Table of Contents
{:.no_toc}
* Will be replaced with the ToC, excluding the "Contents" header
{:toc}



## Environment Prerequisites

<div class="row"> <div class="col-md-6">

Ansible must be present on the *control* machine. See the [Install][] page of
the Ansible Documentation. We use a fairly recent version (≥ 1.9 at the time of
writing) of Ansible. The operating system on the controller is not relevant. We
use Mac OS X and various Linux variants.

The Ansible setup supports Ubuntu 14.04 or Debian 8. The working account on the
**control machine**  must have **ssh access to the server and executors**.
A setup with SSH keys and without passwords is the most straight forward
configuration.

The server and executors must reach each other via the **https** protocol (port
443) to function properly. The **example setup** assumes that all machines have
**fixed ipv4 addresses**. **Custom configuration** of protocol and port, as
well as names instead of addresses is **possible** but outside the scope of
this documentation.

</div> <div class="col-md-6">

[![Environment](/installation/environment.svg)](/installation/environment.svg)


</div> </div>


## Step by Step Install Procedure for a Demo Environment

The following example uses one machine in the role of the server and executor.


1.  We check out the [Cider-CI main project][] including all sub-projects inside
    the control machine:

    `git clone --recursive https://github.com/cider-ci/cider-ci.git`

2. We descend into the deploy directory.

    `cd cider-ci/deploy`

3. We adjust the host ip within the `hosts_demo_single` file:


      [demo]
      demo-machine ansible_ssh_host=192.168.0.31 ansible_ssh_user=root


4. We invoke ansible-playbook to trigger the install:

    `ansible-playbook -i hosts_demo_single play_site.yml -e 'system_admin_password=secret system_admin_login=admin cider_ci_master_secret=REPLACE-WITH-YOUR-SECRET'`


<div class="alert alert-warning" role="alert">
Installing Cider-CI from scratch can take a while (45 minutes are typical for
a virtual machine running on my laptop). It can happen that the
`ansible-playbook` fails due to network timeouts e.g. The playbook is
idempotent and thus can be rerun again at any time.
</div>


## Adding Traits

See [Adding Traits](./advanced.html#adding-traits) on the [Advanced
Installation](./advanced.html) page.



  [Bash Demo Project for Cider-CI]: https://github.com/cider-ci/cider-ci_demo-project-bash
  [Cider-CI Deploy]: https://github.com/cider-ci/cider-ci_deploy
  [Cider-CI main project]: https://github.com/cider-ci/cider-ci
  [Install]: http://docs.ansible.com/intro_installation.html