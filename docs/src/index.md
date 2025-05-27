# Bijections



## Overview

Mathematically, a *bijection* is a one-to-one and onto function between sets. 
In this module, we provide the `Bijection` data type that represents a 
bijection between finite collections of objects. 

A `Dict` in Julia is not one-to-one. Two different keys might have the
same value. A `Bijection` data structure behaves just like a `Dict` except that it
prevents assigning the same value to two different keys.

## Getting started

After `using Bijections` we create a new `Bijection` in one of the
following ways:

* `b = Bijection()`: This gives a new `Bijection` in which the keys
and values are of `Any` type.

* `b = Bijection{S,T}()`: This gives a new `Bijection` in which the
  keys are of type `S` and the values are of type `T`.

* `b = Bijection(x,y)`: This gives a new `Bijection` in which the keys
  are type `typeof(x)`, the values are type `typeof(y)` and the
  key-value pair `(x,y)` is inserted into the `Bijection`.
  
* `b = Bijection(dict::AbstractDict{S, T})`: This gives a new `Bijection` in which the keys
  are type `S`, the values are type `T` and all
  key-value pairs in `dict` are inserted into the `Bijection`.

* `b = Bijection(pair_list::Vector{Pair{S, T}})`: Create a new `Bijection` using a list of pairs.

See also the Mutable page for additional constructor options. 