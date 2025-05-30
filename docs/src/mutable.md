# [Mutable keys](@id mutable)

```@setup example
using Bijections
```

The safest use of a `Bijection` is when the keys and values are immutable.
If a mutable key or value in a `Bijection` is altered, the bijective property
can be compromised. Here is an example:

```@repl example
b = Bijection{Int, Vector{Int}}();
b[1] = [1,2,3]
b[2] = [1,2,4]
b[2][3] = 3
b
```

Notice that `b` contains a repeated value and therefore is not bijective.

Some strategies to avoid this problem include:

* Only use immutable keys and values (such as numbers and strings).
* Use copies of the keys/values in the `Bijection`.
* Don't modify keys/values saved in the `Bijection`.

In case none of these is a viable option, you may need to use an `IdDict`.

## Keys/values as objects

The issue in the example presented above is that distinct Julia objects may be equal, but not the same object. For example:

```@repl example
v = [1,2,3];
w = [1,2,3];
v==w
v===w
```

We may wish to create a `Bijection` in which the keys or values are permitted to be equal, but are distinct objects. Julia's `IdDict` is a variation of `Dict` in which keys/values are considered different if they are distinct object (even if they hold the same data). To replicate this behavior in a `Bijection` use this longer form constructor:

```julia
Bijection{K, V, IdDict{K,V}, IdDict{V,K}}()
```

where `K` is the type of the keys and `V` is the type of the values.

For example:

```@repl example
b = Bijection{Vector{Int}, String, IdDict{Vector{Int},String}, IdDict{String,Vector{Int}}}();
b[ [1,2,3] ] = "alpha";
b[ [1,2,3] ] = "beta";
b("alpha") == b("beta")
b("alpha") === b("beta")
keys(b)
```
