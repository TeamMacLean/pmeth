pmeth
=====

Ruby gem: Reproduction methods for genetic (and other iterative improvement) algorithms, being used to solve permutation problems, where permutations are arrays of unique objects.

Install
---

```

gem install pmeth

```

OR download [here](https://rubygems.org/gems/pmeth)

Usage
----

Currently the methods described below can only be used to rearrange permutations of **>= 10 unique** objects.

For example:

```

a = %w(a b c d e f g h i j)
b = a.shuffle

```

Each method returns a new permutation.

There are currently two mutation methods and one recombination method, which can be used as follows:

```

PMeth.mutate(a)

PMeth.mini_mutate(a)

PMeth.recombine(a,b)

```