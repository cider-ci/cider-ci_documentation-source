---
title: Pushing Status Messages to GitHub
classes: image-with-border
---
{::options parse_block_html="true" /}

#Pull Mode

This guides describes how to configure an executor to operate in _pull mode
only_.

## Background

<div class="row"> <div class="col-md-6">

The default communication between the Cider-CI server and an Cider-CI executor
uses bidirectional HTTPS.

Sending data from a executor to the server is absolutely required for the
executor to function within the environment. It is possible to configure
a particular executor such that only this way of communication is used.

<div class="alert alert-danger">
Don't configure pull mode only if you don't have to.
It has a several drawbacks.
</div>


</div> <div class="col-md-6">

~~~
    ╔═══════════════════════════════════════════╗
    ║                                           ║
    ║                                           ║
    ║            Cider-CI  Executor             ║
    ║                                           ║
    ║                                           ║
    ╚═════════▲════════════════════════╦════════╝
              │                        ║
              │                        ║
              │                        ║
              │                        ║
            HTTPS                    HTTPS
       (push dispatch)       (ping, sync, config,
              │                 pull dispatch)
              │                        ║
              │                        ║
              │                        ║
    ╔═════════╩════════════════════════▼════════╗
    ║                                           ║
    ║                                           ║
    ║              Cider-CI Server              ║
    ║                                           ║
    ║                                           ║
    ╚═══════════════════════════════════════════╝
~~~
</div></div>


## Configuration

### Via Cider-CI Deploy

<div class="row"> <div class="col-md-6">
The preferred way to configure pull mode only is via a host configuration in
the inventory for the Cider-CI Deploy. Set the value of the property
`executor_base_url` to `NULL` in this case.

Consider to adjust the value of `executor_sync_interval_pause_duration` too.
The shorter the quicker dispatch will be preformed in pull mode only. But it
will also increase the data send forth and back and the overall load on the
systems. Usable values range from `1 Second` to `60 Seconds`.


</div> <div class="col-md-6">

~~~ yaml
# enabled for pull mode only
executor_base_url: NULL

executor_sync_interval_pause_duration: 10 Seconds
~~~

</div></div>


### Via the User-Interface

It is possible to set the corresponding value of `Base URL` in the user
interface. Follow `Administration` → `Executors` → `Show more` → `Edit` to find
the setting.

{: .text-warning}
A rerun of the Cider-CI deploy will reset this value for managed executors to
how it is configured in the inventory.




