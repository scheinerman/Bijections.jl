```@meta
DocTestSetup = quote
    using Bijections
end
```

# Operations



## Creating an inverse `Bijection`

There are two functions that take a `Bijection` and return a new
`Bijection` that is the functional inverse of the original:
[`inv`](@ref) and [`active_inv`](@ref).

### Independent inverse: `inv`

Given a `Bijection` `b`, calling `inv(b)` creates a new `Bijection`
that is the inverse of `b`. The new `Bijection` is completely independent
of the original, `b`. Changes to one do not affect the other:

```jldoctest
julia> b = Bijection{Int,String}()
Bijection{Int64, String, Dict{Int64, String}, Dict{String, Int64}}()

julia> b[1] = "alpha"
"alpha"

julia> b[2] = "beta"
"beta"

julia> bb = inv(b)
Bijection{String, Int64, Dict{String, Int64}, Dict{Int64, String}} with 2 entries:
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
[...]
```

### Active inverse: `active_inv`

The `active_inv` function also creates an inverse `Bijection`, but in this
case the original and the inverse are actively tied together.
That is, modification of one immediately affects the other.
The two `Bijection`s remain inverses no matter how either is modified.

```jldoctest
julia> b = Bijection{Int,String}()
Bijection{Int64, String, Dict{Int64, String}, Dict{String, Int64}}()

julia> b[1] = "alpha"
"alpha"

julia> b[2] = "beta"
"beta"

julia> bb = active_inv(b)
Bijection{String, Int64, Dict{String, Int64}, Dict{Int64, String}} with 2 entries:
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

```@repl example
# The order of iteration is not guaranteed, so this can't be a doctest # hide
using Bijections # hide
b = Bijection(1 => "alpha", 2 => "beta", 3 => "gamma");
for (x, y) in b; println("$x --> $y"); end
```

## Composition

Given two `Bijection`s `a` and `b`, their composition `c = a ∘ b` or `c = compose(a, b)` is a new `Bijection` with the property that `c[x] = a[b[x]]` for all `x` in the
domain of `b`.

```jldoctest
julia> a = Bijection{Int,Int}(1 => 10, 2 => 20);

julia> b = Bijection{String,Int}("hi" => 1, "bye" => 2);

julia> c = a ∘ b;

julia> c["hi"]
10
```
