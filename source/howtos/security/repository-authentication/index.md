# Repository Authentication


Depending on the protocol and configuration of the remote git endpoint
authentication might be required to access repositories.

The SSH protocol requires authentication due to its nature. The HTTP protocol
requires authentication for git pushes (rarely implemented within a CI
infrastructure) and for pulls if the remote is configured that way. So called
*private* repositories in GitHub parlance require authentication by default.

The key to implement authentication for Cider-CI is to understand which users
are involved. The following facts are valid for a standard installation via the
[Cider-CI Deploy Project][], see also the [Installation][] guides.


~~~
┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                                                │
│                                         Remote Git Repository / Server                                         │
│                                                                                                                │
└───────────────┬─────────────────────────────┬─────────────────▲────────────────────────┬──────────────▲────────┘
                │                             │                                          │
                │                             │                 │                        │              │
                │                             │                                          │
           clone/fetch                   clone/fetch     push (optional)            clone/fetch   push (optional)
                │                             │                                          │
                │                             │                 │                        │              │
                │                             │                                          │
┌───────────────┼───────────────┐     ┌───────┼─────────────────┼───────────┐    ┌───────┼──────────────┼────────┐
│               ▼               │     │       ▼                             │    │       ▼                       │
│  ┌─────────────────────────┐  │     │  ┌────────┐  ┌──────────┴─────────┐ │    │   ┌──────────────────┴─────┐  │
│  │   cider-ci_repository   │  │     │  │  root  │  │ cider-ci_exec-user │ │    │   │   cider-ci_executor    │  │
│  └─────────────────────────┘  │     │  └────────┘  └────────────────────┘ │    │   └────────────────────────┘  │
│                               │     │                                     │    │                               │
│        Cider-CI Server        │     │       Cider-CI Linux Executor       │    │   Cider-CI Windows Executor   │
│                               │     │                                     │    │                               │
└───────────────────────────────┘     └─────────────────────────────────────┘    └───────────────────────────────┘
~~~

## Users

Cider-CI uses standard `git` system commands to access remote repositories. On
the server the user `cider-ci_repository` clones and fetches from remote
repositories. Therefore the `cider-ci_repository` must have read access
to the remote repository.

On a Linux executor the executor service runs under `root`. Scripts are
executed under the `cider-ci_exec-user`. Therefore to clone and fetch
repositories in the normal workflow the `root` user must be granted read
access. If any git integration is to be performed as part of a `Cider-CI Job`
then the `cider-ci_exec-user` has to be granted access. If follows that pull
and push privileges are separated by default.

On a Windows executor the user `cider-ci_executor` pulls and runs the
corresponding scripts. <span class='text-warning'> Separating push and pull
privileges must be implemented on the remote git server if there is a Windows
executor involved. </span>


## Protocols

We investigate some of the obstacles imposed by the protocols.

### HTTP / HTTPS

It is technically possible to integrate the `username:password` as part of the
URI for the `http/https` protocol. This is probably the most easy approach but
it is also vulnerable. By accident (or by provoking exceptions) the password
could appear in logfiles or other channels. We only recommend this method for
non public repositories and better yet non public accessible Cider-CI
instances. Additionally check that all the users of the Cider-CI instance can
be trusted with this information.

One alternative to URLs is the `.netrc` file. This comes via `libcurl` which is
used by `git`. See the [Curl Manual][].


### SSH

Access can be granted by creating a ssh key pair and enabling the public key on
the remote server. There is one particular trip hazard: SSH services are
usually configured not to allow connections to remote hosts which are not
white-listed. Connecting once to the remote as the target user will reveal
problems and might even provide a solution  by adding a line to the
`known_hosts` file interactively.

  [Installation]: /installation/index.html

  [Cider-CI Deploy Project]: https://github.com/cider-ci/cider-ci_deploy
  [Curl Manual]: http://curl.haxx.se/docs/manual.html
