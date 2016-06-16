---
title: Composing JSON Data
---
{::options parse_block_html="true" /}


# Composing JSON Data

We wish to **achieve composability** and **avoid repetition** when specifying
"things" to be "done". Cider-CI provides the [inheritance] and means to
[sharing data] to achieve this. Both require a mechanism to merge data. This
page discusses the inner workings of this.

<div class="row"> <div class="col-md-6">

The project configuration is encoded in JSON format. JSON provides maps, arrays
and some primitive types. The obvious solution when composing JSON data is to
use some kind of _"recursive merging"_. This works well for maps. But it is
impossible to specify a general merging strategy for arrays. Arrays are ordered
and provide indexes. A meaningful composition must consider the means of the
data in the array to produce a sensible composition.

We avoid the overhead of considering semantics of arrays by **favoring maps**
in the project configuration of Cider-CI.  Whenever some _set_, or _collection_
like structure is the natural encoding for some entities we will use a map. The
following extract gives a simple example.

</div> <div class="col-md-6">

~~~yaml
scripts:
  prepare:
    body: do some preparing
  test:
    body: test
    start_when:
      'prepared':
        script_key: prepare
        states: [ "passed" ]
~~~

Here the contents of `scripts` and `start_when` could have been arrays. In the
case of scripts the keys are important to be used as reference.

</div> </div>


## The Deep-Merge Strategy

<div class="row"> <div class="col-md-6">

The canonical definition of _deep-merge_ is mnemonic and easy to understand.
The following almost formal definition will help to clarify doubts.

### Definition

Let `m1` and `m2` be a maps, and let `m` be the result of `(m1 deep-merge m2)`
Then the  following holds true:

1. If the key `k1` with the value `v1` is present in `m1` but not in `m2`, then
  the key value pair `(k1,v1)` is be present in `m`.

2. If the key `k2` with the value `v2` is present in `m2` but not in `m1`, then
  the key value pair `(k2,v2)` is be present in `m`.

3. If `k` is present in `m1` and `m2`

    1. and  `v1` and `v2` are both maps, then the pair `(k,  ( v1 deep-merge v2))` is present in `m`.

    2. otherwise the pair `(k,v2)` is present in `m`.

</div> <div class="col-md-6">

### Structural Properties

We expand  into some structural properties of deep-merge. It is not important
to understand following but it deepens the understanding and emphasizes the
composability of the chosen method in Cider-CI to aggregate JSON data.

Let `S` be the set of all JSON encoded data which has a map as its top level
data structure, let `{}` denote the empty map, and `⊕` the shorthand symbol for
`deep-merge`. Then `(a ⊕ (b ⊕ c)) = (a ⊕ b) ⊕ c)) ∈ S` and `(a ⊕ {}) = ({} ⊕ a)
= a` for all `a, b, c  ∈ S`. In other words: the `deep-merge` operation and the
set of all maps in JSON form a **[monoid]** `(S,{},⊕)`. However, it is clearly
**not commutative** and there exists only the trivial inverse element `{}`.

</div> </div>

  [sharing data]: /project-configuration/advanced/sharing-data.html
  [inheritance]: /project-configuration/advanced/inheritance.html
  [monoid]: https://en.wikipedia.org/wiki/Monoid
