# Bijections

This package provides a `Bijection` data type for Julia.


A `Dict` in Julia is not one-to-one. Two different keys might have the
same value. This data structure behaves just like a `Dict` except it
blocks assigning the same value to two different keys.

## Getting Started

After `using Bijections` we create a new `Bijection` in one of the
following ways:

* `b = Bijection()`: This gives a new `Bijection` in which the keys
and values are of `Any` type.

* `b = Bijection{S,T}()`: This gives a new `Bijection` in which the 
  keys are of type `S` and the values are of type `T`.

* `b = Bijection(x,y)`: This gives a new `Bijection` in which the keys
  are type `typeof(x)`, the values are type `typeof(y)` and the
  key-value pair `(x,y)` is inserted into the `Bijection`.

## Adding and deleting pairs

Once a `Bijection`, `b`, is created, we add a new key-value pair in
the same manner as with a `Dict`:
```julia
julia> b[1] = "hello"
"hello"

julia> b[2] = "bye"
"bye"
```
Notice, however, that if we add a new key with a value that already
exists in the `Bijection` an error ensues:
```julia
julia> b[3] = "hello"
ERROR: One of x or y already in this Bijection
```
Likewise, if a key already has a value it cannot be changed by giving
it a new value:
```julia
julia> b[1] = "ciao"
ERROR: One of x or y already in this Bijection
```

If we wish to change the value associated with a given key, the pair
must first be deleted using `delete!`:
```julia
julia> delete!(b,1)
Bijection{Any,Any} (with 1 pairs)

julia> b[1] = "ciao"
"ciao"
```

## Using a `Bijection`

To access a value associated with a given key, we use the same syntax
as for a `Dict`:
```julia
julia> b[1]
"ciao"

julia> b[2]
"bye"
```

If the key is not in the `Bijection` an error is raised:
```julia
julia> b[3]
ERROR: KeyError: 3 not found
```

Since the values in a `Bijection` must be distinct, we can give a
value as an input and retrieve its associate key. The function
`inverse(b,y)` finds the value `x` such that `b[x]==y`. However, we
provide the handy short cut `b(y)`:
```julia
julia> b("bye")
2

julia> b("ciao")
1
```

Naturally, if the requested value is not in the `Bijection` an error
is raised:
```julia
julia> b("hello")
ERROR: KeyError: hello not found
```

## Inspection

Thinking of a `Bijection` as a mapping between finite sets, we
provide the functions `domain` and `image`. These return,
respectively, the set of keys and the set of values of the
`Bijection`.
```julia
julia> domain(b)
Set(Any[2,1])

julia> image(b)
Set(Any["bye","ciao"])
```

The `collect` function returns the `Bijection` as an array of
key-value pairs:
```julia
julia> collect(b)
2-element Array{Tuple{Any,Any},1}:
 (2,"bye")
 (1,"ciao")
```

The `length` function returns the number of key-value pairs:
```julia
julia> length(b)
2
```

The `isempty` function returns `true` exactly when the `Bijection`
contains no pairs:
```julia
julia> isempty(b)
false
```

## To do list

These are features I may get around to adding:

* Create an `inv(b)` function which creates a new `Bijection`
that reverses key-value pairs in `b`

* Create an `active_inv(b)` function that, like `inv`, creates an
  inverse but that is tied to `b` so that any modification of one
  affects the other.

* A `Bijection` ought to be iterable, but that's not implemented yet.
