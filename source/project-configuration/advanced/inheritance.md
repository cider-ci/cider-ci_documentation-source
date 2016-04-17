---
title: Hierarchy and Inheritance
---
{::options parse_block_html="true" /}

# Hierarchy and Inheritance


<div class="row"> <div class="col-md-6">

A context can include itself other contexts by the _contexts_ key. Each of them
allows the same properties as its parent context. The properties
`task_defaults` and `script_defaults` pass on their values through the context
hierarchy where items deeper in the hierarchy override values defined earlier
if keys overlap. The precises mechanism is described on the [composing data]
page.

We explore the inheritance mechanism by the following example on this page.

~~~yaml
context:
  task_defaults:
    priority: 1
    max_trials: 2
  tasks:
    'task 1': {}
    'task 2':
      priority: 2
  contexts:
    'sub context':
      tasks_defaults:
        priority: 3
      tasks:
        'task 3': {}
        'task 4':
          max_trials: 4
          priority: 4
~~~

This results in the following values for the tasks.


|-----------+------------+--------------|
| Task name | `priority` | `max_trials` |
|-----------+------------+--------------|
| _task 1_  | 1          | 2            |
| _task 2_  | 2          | 2            |
| _task 3_  | 3          | 2            |
| _task 4_  | 4          | 4            |
|-----------+------------+--------------|
{: .table .table-striped }


</div> <div class="col-md-6">


!["Contexts, Hierarchy and Inheritance"][hierarchy]

</div> </div>



  [composing data]: /project-configuration/advanced/composing-data.html
  [hierarchy]: /project-configuration/advanced/hierarchy.svg "Contexts, Hierarchy and Inheritance"
