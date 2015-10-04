---
title: Upgrading and Updating
---
{::options parse_block_html="true" line_numbers="false" /}

# Upgrading and Updating
{:.no_toc}

This is a guide to upgrade or update your Cider-CI environment.


### Table of Contents
{:.no_toc}
* Will be replaced with the ToC, excluding the "Contents" header
{:toc}


## General Strategy

Deploying an upgrade to a higher version of Cider-CI or just deploying and
updated inventory is technically no different from performing an initial deploy
as covered in the [deploy section][] of the [Setup and Deploy Guide][].

  [deploy section]: ../setup-and-deploy/index.html#deploy
  [Setup and Deploy Guide]: ../setup-and-deploy/index.html

You probably do not want to set the administrator password and thus we invoke
the following command from the  [Cider-CI Deploy Project] within the complete
[Cider-CI Master Project].

```ANSIBLE_LOAD_CALLBACK_PLUGINS=1 DEPLOY_ROOT_DIR=`pwd` ansible-playbook -i PATH-TO-OUR-INVENTORY play_site.yml```

### Clean Slate Deployment

A clean slate deploy tries to remove all Cider-CI components before installing
new ones. This involves also a restart of the target machine. Clean slated
deploys are enforced by setting the `clean_slate` variable to true.

```ANSIBLE_LOAD_CALLBACK_PLUGINS=1 DEPLOY_ROOT_DIR=`pwd` ansible-playbook -i PATH-TO-OUR-INVENTORY play_site.yml -e 'clean_slate=true'```


## Adding, Executors, Updating Inventory and Variables

Adding new hosts or change variables is best performed by triggering a new
deployment as described in the [General Strategy](#general-strategy).

<span class="text-warning"> Removing executors from the inventory will not
remove the internal registration of those.</span> They should be removed via
the user interface: `Administration` → `Executors` → `Show more` → `Delete`.

<div class="alert alert-danger">
New executors **must be added properly**, e.g. by updating the inventory and
running a deploy. It does not suffice to just copy or clone executor machines.
</div>

## Upgrading

We assume that all adjustments for our Cider-CI environment are kept in
a inventory outside the cloned [Cider-CI Master Project]. The most convenient
way is then to start with a fresh clone of the desired version:

```git clone https://github.com/cider-ci/cider-ci.git -b TARGET-VERSION --recursive```

The `TARGET-VERSION` can be a version tag, such as `Cider-CI_3.7.0` or a branch
name, or even the hash of a commit.

After this we descend into `cider-ci/deploy` and proceed as mentioned mentioned above.

### Target Version Considerations

The [Cider-CI Deploy Project] <span class="text-danger"> does not support
downgrades.</span> Deploys are tested for successive minor versions, e.g. from
`3.6.0`, to `3.7.0`, to `3.7.0`. This is the safe procedure, but skipping minor
versions should work.

Some upgrades might trigger a [Clean Slate
Deployment](#clean-slate-deployment).

### Deploy to Staging First

It is highly recommended to deploy new versions to a staging environment
which is as similar as possible to a production environment.

### Using Git `update` instead of `clone`

You can also just update your already cloned project. But this must be done
recursively then. Updating is usually faster. But there are can be
circumstances where updating recursively does not work without applying some
other lower level Git commands. <span class="text-warning"> It is very
important that that all submodules are at the proper version as referenced from
their super module. </span>

  [Cider-CI Deploy Project]: https://github.com/cider-ci/cider-ci_deploy
  [Cider-CI Master Project]: https://github.com/cider-ci/cider-ci
