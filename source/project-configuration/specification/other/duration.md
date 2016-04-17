---
title: Durations
---
{::options parse_block_html="true" /}

# Durations

Durations are used in the `timeout` value of a [script] or in the
`dispatch_storm_delay_duration` value of a [task] for example.
A duration is always encoded as a string. Here are a few examples:

* `1 Second`,
* `2 minutes 30 seconds`, or equally
* `2.5 minutes`,
* `1 hour and 333 milliseconds`, and
* `1 Year and 3 Months and 3 weeks, 3 days , 7 minutes plus 1 second and 3 milliseconds`.

Duration values in the project configuration are **strictly validated** and the
configuration will be **rejected** if the validation fails.
{: .text-warning}

The **rules for parsing a duration** can be described as follows: The words
`and`, `plus`, and the symbol `,` are ignored. After dropping those words
a  duration value consists of pairs. Each pair consists of an number (words
like `one`, `two` and so forth are not allowed) and an English term specifying
the unit. The available units can be inspected in the source code:
<https://github.com/cider-ci/cider-ci_clj-utils/blob/v4/src/cider_ci/utils/duration.clj>.


  [script]: /project-configuration/specification/script.html
  [task]: /project-configuration/specification/task.html
