---
title: Managing Disk Space on Executors
---
{::options parse_block_html="true" /}

# Managing Disk Space on Executors

## Working Directories

The main disk usage on executors is usually caused by working directories.
A working directory is a shallow git clone of the project. For every trial
a new clone is created. Working directories (and the in memory representation)
of trials are kept for a while after a trial has finished. This time can be
configured with the per executor host variable
`executor_trial_retention_duration` in your inventory.

~~~yaml
executor_trial_retention_duration: 5 Minutes
~~~
{: .text-warning}
<span class="text-warning">
The working directories sweeper does not follow symbolic links or tries to clean
anything outside the working directory. </span> This is a feature.
It allows for certain caching implementations which can span over the lifetime
of multiple trials.

## Repositories Cache

Every executor has a repository cache where full clones of all required
repositories are kept. <span class="text-warning"> The cached repositories are
not cleaned automatically. </span> You can delete the cache manually if it
turns out to be a problem. The default location on Linux is
`/var/local/cider-ci/executor/tmp/repositories-dir`, and
`C:\cider-ci\executor\tmp\repositories-dir` on Windows.

It is possible to delete repositories during normal operation of an executor.
The probability of running into problems exists, but it is very low. You can
restart the executor or the whole machine in this unlikely event.
