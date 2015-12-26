---
title: Project Configuration - Shared Directives
---
{::options parse_block_html="true" /}

# Shared Directives

Some configuration directives can exist in several places. There are also
directives which are similar similar in structure and semantics. These
directives are documented on this page.


## Attachments

The task configuration can contain the keys `:tree-attachments` and
`:trial-attachments`. They define files which are uploaded to the server after
the trial has been processed.

Every file in the working directory is passed though the filters with its path
specified relative to the working directory.

|-----------------+----------+------------------------------------------------------------------------------------------------------------|
| Key/Property    | Presence | Value                                                                                                      |
|-----------------+----------+------------------------------------------------------------------------------------------------------------|
| `content-type`  | required | String - Sets the HTML content type for delivering the attachment.                                         |
| `include-match` | required | String (Regular Expression) - Every file matching the expression will be uploaded (unless it is excluded). |
| `exclude-match` | optional | String (Regular Expression) - Files passing the `include-match` can be filtered out with this one.         |
|-----------------+----------+------------------------------------------------------------------------------------------------------------|
{: .table .table-striped }


~~~yaml
trial-attachments:
  logs:
    content-type: text/plain
    include-match: ^.+\.log$

tree-attachments:
  - content-type: "application/json"
    include-match: ^result\.json$
~~~

It is possible to use either a map of maps or a list of maps to specify
attachments. The latter is more compact in notation but the former enables deep
merging, see the [Advanced Topics][] page.


Attachments should be used with caution. They require **storage space** on the
server and they have a **negative impact** on the **execution time** and on
**parallelization** as a consequence.
{: .text-warning}


## Include-Match and Exclude-Match

Various directives can or must include the keys `include-match` respectively
`exclude-match`. The are used to filter some list of strings.

Both vales are given as strings. Each is converted to a regular expression
matcher. A string will pass the filter if it matches the `include-match` and if
it does not match the `exclude-match`. The `exclude-match` is in most cases
optional.

  [Advanced Topics]: /project-configuration/advanced.html

