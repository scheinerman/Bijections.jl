# Using `Bijections`


## Adding and deleting key/value pairs

Once a `Bijection`, `b`, is created, we add a new key-value pair in
the same manner as with a `Dict`:
```
julia> b = Bijection{Int, String}()
Bijection Dict{Int64, String}()

julia> b[1] = "hello"
"hello"

julia> b[2] = "bye"
"bye"
```
Notice, however, that if we add a new key with a value that already
exists in the `Bijection` an error ensues:
```
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

## Accessing values from keys, and keys from values

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