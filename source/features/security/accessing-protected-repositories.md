# Accessing Protected (Private) Repositories

~~~
┌───────────────────────────────────────────────────────────────────────────────────┐
│                                                                                   │
│                          Remote Git Repository / Server                           │
│                                                                                   │
└───────────────────┬───────────────────────────────┬─────────────────▲─────────────┘
                    │                               │                 │
                    │                               │                 │
                    │                               │                 │
               clone/fetch                     clone/fetch            │ push
                    │                               │                 │
                    │                               │                 │
                    │                               │                 │
┌───────────────────┼───────────────────┐   ┌───────┼─────────────────┼─────────────┐
│                   ▼                   │   │       ▼                 │             │
│   ┌───────────────────────────────┐   │   │  ┌────────┐  ┌──────────┴─────────┐   │
│   │      cider-ci_repository      │   │   │  │  root  │  │ cider-ci_exec-user │   │
│   └───────────────────────────────┘   │   │  └────────┘  └────────────────────┘   │
│                                       │   │                                       │
│            Cider-CI Server            │   │           Cider-CI Executor           │
│                                       │   │                                       │
└───────────────────────────────────────┘   └───────────────────────────────────────┘
~~~

## Users

Cider-CI uses standard `git` system commands to access remote repositories. On
the server the user `cider-ci_repository` clones and fetches from remote
repositories. Therefore the `cider-ci_repository` must have read access
to the remote repository.

On the executor the executor service runs under `root`. Scripts are executed
under the `cider-ci_exec-user`. Therefore to clone and fetch repositories in
the normal workflow the `root` user must be granted read access. If any git
integration is to be performed as part of a `Cider-CI Job` then the
`cider-ci_exec-user` has to be granted access.


## Protocols


### HTTP / HTTPS

It is technically possible to integrate the `username:password` as part of the
URI for the `http/https` protocol. This is probably the most easy approach but
it is also vulnerable. By accident (or by provoking exceptions) the password
could appear in logfiles or other channels. We only recommend this method for
non public repositories (better yet non public accessible Cider-CI instances)
and when all the users of the Cider-CI instance can be trusted with this
information.

One alternative to URLs is the `.netrc` file.  This comes via `libcurl` which
is used by `git`. See the [Curl Manual](http://curl.haxx.se/docs/manual.html).


### SSH

Access can be granted by creating a ssh key pair and enabling the public key on
the remote server. There is one particular trip hazard: SSH services are
usually configured not to allow connections to remote hosts which are not
white-listed. Connecting once to the remote as the target user will reveal
problems and might even provide a solution  by adding a line to the
`known_hosts` file interactively.
