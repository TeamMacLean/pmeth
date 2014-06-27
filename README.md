pmeth
=====
[![Gem Version](https://badge.fury.io/rb/pmeth.svg)](http://badge.fury.io/rb/pmeth)
[![Build Status](https://drone.io/github.com/edwardchalstrey1/pmeth/status.png)](https://drone.io/github.com/edwardchalstrey1/pmeth/latest)

Ruby gem: Reproduction methods for genetic (and other iterative improvement) algorithms, being used to solve permutation problems, where permutations are arrays of unique objects.

Install
---

```
gem install pmeth
```

OR download [here](https://rubygems.org/gems/pmeth)

Usage
----

The methods below create new permutation arrays from existing ones.

For example:

```ruby
a = %w(a b c d e f g h i j)
b = a.shuffle
```

Each method returns a new permutation.

There are currently two mutation methods and one recombination method, which can be used as follows:

```ruby
PMeth.chunk_mutate(a)
PMeth.swap_mutate(a)
PMeth.adjacent_swap(a)
PMeth.recombine(a,b)
```

Other methods:

```factors``` and ```prime?``` methods have been added to Integer class. See [lib/pmeth](https://github.com/edwardchalstrey1/pmeth/blob/master/lib/pmeth.rb)

How methods work
-----

### Chunk mutate

One permutation is taken as input (the permutation to be mutated). It is split into chunks of size X, where X is a random whole number that the permutation array's size is divisible by. The objects within the chunk are then shuffled, to give the new "mutant" permutation. 

If the size of the permutation (array length) is a prime number, one of the objects (chosen at random) is removed first. The shortened permutation is mutated as described above, then the deleted objected is added into the mutant, at the index it was located in the original permutation.

For chunk_mutate to work, permutations must be at least 4 unique objects long.

### Swap mutate

One permutation is taken as input. Two of the the objects, chosen at random, swap position.

### Adjacent swap

One permutation is taken as input. An object, chosen at random, is swapped with one of it's immediate neighbours.

### Recombine

Two parent permutations are used as input. Each of the parents are split into chunks of size X, where X is a random whole number that the permutation array's size is divisible by. One of the chunks from parent 2 is chosen at random, to be recombined with parent 1. The "child" permutation, starts out as a copy of parent 1, then the chosen chunk from parent 2 replaces the equivalent chunk from parent 1. To avoid duplicating or losing unique objects in the child, each object from the chunk being displaced by the "chosen chunk", is placed into the position it's corresponding object (that holds the same position in the chosen chunk) occupies in parent 1. This results in a child permutation that has some parts ordered in the same way as parent 1, a chunk that is in the same order as in parent 2, and some objects different positions than in either parent.

If the size of each parent permutation (array length) is a prime number, one of the objects (chosen at random) is removed first. The shortened permutation is mutated as described above, then the deleted objected is added into the mutant, at the index it was located in the original permutation.

For short permutations (arrays with a small number of unique objects), recombine can sometimes produce a child that is identical to one of the parents.
