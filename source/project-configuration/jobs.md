# Jobs

The `jobs` key introduces a map of maps, see [Map of Maps] in [Advanced
Topics], each mapping to a [Job](#job). This structure specifies available jobs
and relations between them.



## Example

    jobs:

      job-prerequisite:

        name: Jobs - Dependencies and Triggers - Prerequisite
        description: |
          This one serves as a prerequisite to "job-depends".
          Additionally it will be automatically triggered if a branch matching the
          regular expression /^trigger-prerequisite$/ is updated.

        run-on:
        - type: branch
          include-match: ^trigger-prerequisite$

        context: {}

      job-dependent:

        name: Jobs - Dependencies and Triggers - Dependent
        description: |
          This demo can only be started if the "job-prerequisite" has passed. There
          is also a corresponding trigger defined for the sake of demonstration.

        depends-on:
        - type: job
          job: job-prerequisite
          states: [passed]

        run-on:
        - type: job
          job: job-prerequisite
          states: [passed]

        context: {}
  {: .language-yaml}

The above example has some properties removed from the original
[job-dependencies.yml](/demo-project/cider-ci/jobs/job-dependencies.yml)
to highlight the essence for this page.




# The Job {#job}

The keys of the _jobs_ map name available jobs for reference. The values
describe, specify and relate them.


|---------------+----------+--------------------------------------------------------------------------------------------------------------------------------|
| Key/Property  | Presence | Value                                                                                                                          |
|---------------+----------+--------------------------------------------------------------------------------------------------------------------------------|
| `context`     | required | Map - Container for Tasks and related properties.                                                                              |
| `depends-on`  | optional | Array of Maps - The jobs and their state on which the job depends on (combined with conjunction). Example: [job-dependencies]  |
| `description` | optional | String                                                                                                                         |
| `job-key`[^i] | yes[^i]  | String - The stringified representation of key in the `jobs` map.                                                              |
| `name`        | yes[^r]  | String - The visible name of the job.                                                                                          |
| `run-on`      | optional | Array of Maps - Events on which the job will be automatically started (combined with disjunction). Example: [job-dependencies] |
|---------------+----------+--------------------------------------------------------------------------------------------------------------------------------|
{: .table .table-striped }


[^r]: Defaults to the string that represents the key.

[^i]: This is an invisible or virtual property in the dotfile. It is used  during evaluation of the dotfile where any existing value would be overwritten.

  [Task]: /project-configuration/tasks.html#task
  [Map of Maps]: /project-configuration/advanced.html#map-of-maps
  [Advanced Topics]: /project-configuration/advanced.html

  [job-dependencies]: /demo-project/cider-ci/jobs/job-dependencies.yml

