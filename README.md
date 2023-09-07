# Bijections

A `Bijection` data type for Julia.


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
  
* `b = Bijection(dict::AbstractDict{S, T})`: This gives a new `Bijection` in which the keys
  are type `S`, the values are type `T` and all
  key-value pairs in `dict` are inserted into the `Bijection`.

* `b = Bijection(pair_list::Vector{Pair{S, T}})`: Create a new `Bijection` using a list of pairs.

## Adding and deleting pairs

Once a `Bijection`, `b`, is created, we add a new key-value pair in
the same manner as with a `Dict`:
```
julia> b[1] = "hello"
"hello"

julia> b[2] = "bye"
"bye"
```
Notice, however, that if we add a new key with a value that already
exists in the `Bijection` an error ensues:
```
julia> b = Bijection{Int, String}()
Bijection Dict{Int64, String}()

julia> b[3] = "hello"
ERROR: One of x or y already in this Bijection
```
Likewise, if a key already has a value it cannot be changed by giving
it a new value:
```
julia> b[1] = "ciao"
ERROR: One of x or y already in this Bijection
```

If we wish to change the value associated with a given key, the pair
must first be deleted using `delete!`:
```
julia> delete!(b,1)
Bijection Dict{Int64, String} with 1 entry:
  2 => "bye"

julia> b[1] = "ciao"
"ciao"
```

## Using a `Bijection`

To access a value associated with a given key, we use the same syntax
as for a `Dict`:
```
julia> b[1]
"ciao"

julia> b[2]
"bye"
```

If the key is not in the `Bijection` an error is raised:
```
julia> b[3]
ERROR: KeyError: 3 not found
```

Since the values in a `Bijection` must be distinct, we can give a
value as an input and retrieve its associate key. The function
`inverse(b,y)` finds the value `x` such that `b[x]==y`. However, we
provide the handy short cut `b(y)`:
```
julia> b("bye")
2

julia> b("ciao")
1
```

Naturally, if the requested value is not in the `Bijection` an error
is raised:
```
julia> b("hello")
ERROR: KeyError: hello not found
```

## Creating an inverse `Bijection`

There are two functions that take a `Bijection` and return a new
`Bijection` that is the functional inverse of the original:
`inv` and `active_inv`.

### Independent inverse: `inv`
Given a `Bijection` `b`, calling `inv(b)` creates a new `Bijection`
that is the inverse of `b`. The new `Bijection` is completely independent
of the original, `b`. Changes to one do not affect the other:
```
julia> b = Bijection{Int,String}()
Bijection Dict{Int64, String}()

julia> b[1] = "alpha"
"alpha"

julia> b[2] = "beta"
"beta"

julia> bb = inv(b)
Bijection Dict{String, Int64} with 2 entries:
  "alpha" => 1
  "beta"  => 2

julia> bb["alpha"]
1

julia> bb["alpha"]
1

julia> b[3] = "gamma"
"gamma"

julia> bb["gamma"]
ERROR: KeyError: key "gamma" not found
```

### Active inverse: `active_inv`

The `active_inv` function also creates an inverse `Bijection`, but in this
case the original and the inverse are actively tied together.
That is, modification of one immediately affects the other.
The two `Bijection`s remain inverses no matter how either is modified.

```
julia> b = Bijection{Int,String}()
Bijection Dict{Int64, String}()

julia> b[1] = "alpha"
"alpha"

julia> b[2] = "beta"
"beta"

julia> bb = active_inv(b)
Bijection Dict{String, Int64} with 2 entries:
  "alpha" => 1
  "beta"  => 2
  
julia> b[3] = "gamma"
"gamma"

julia> bb["gamma"]
3
```

## Iteration

`Bijection`s can be used in a `for` statement just like Julia
dictionaries:
```
julia> for (x,y) in b; println("$x --> $y"); end
2 --> beta
3 --> gamma
1 --> alpha
```



## Inspection

Thinking of a `Bijection` as a mapping between finite sets, we
provide the functions `domain` and `image`. These return,
respectively, the set of keys and the set of values of the
`Bijection`.
```
julia> domain(b)
Set(Any[2,1])

julia> image(b)
Set(Any["bye","ciao"])
```

The `collect` function returns the `Bijection` as an array of
key-value pairs:
```
julia> collect(b)
2-element Array{Tuple{Any,Any},1}:
 (2,"bye")
 (1,"ciao")
```

The `length` function returns the number of key-value pairs:
```
julia> length(b)
2
```

The `isempty` function returns `true` exactly when the `Bijection`
contains no pairs:
```
julia> isempty(b)
false
```
