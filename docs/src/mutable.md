# Bijections for Mutable Structures

## Mutating keys/values can lead to corruption

The safest use of a `Bijection` is when the keys and values  are immutable. 
If a mutable key or value in a `Bijection` is altered, the bijective property 
can be compromised. Here is an example:
```
julia> b = Bijection{Int, Vector{Int}}();

julia> b[1] = [1,2,3]
3-element Vector{Int64}:
 1
 2
 3

julia> b[2] = [1,2,4]
3-element Vector{Int64}:
 1
 2
 4

julia> b[2][3] = 3
3

julia> b
Bijection{Int64, Vector{Int64}, Dict{Int64, Vector{Int64}}, Dict{Vector{Int64}, Int64}} with 2 entries:
  2 => [1, 2, 3]
  1 => [1, 2, 3]
```
Notice that `b` contains a repeated value and therefore is not bijective. 

Some strategies to avoid this problem include:
* Only use immutable keys and values (such as numbers and strings).
* Use copies of the keys/values in the `Bijection`.
* Don't modify keys/values saved in the `Bijection`.

In case none of these is an option, we provide the following additional alternative.



## Keys/values as objects

The issue in the example presented above is that distinct Julia objects may be equal, but not the same object. For example:
```
julia> v = [1,2,3];

julia> w = [1,2,3];

julia> v==w
true

julia> v===w
false
```

We may wish to create a `Bijection` in which the keys or values are permitted to be equal, but are distinct objects. Julia's `IdDict` is a variation of `Dict` in which keys/values are considered different if they are distinct object (even if they hold the same data). To replicate this behavior in a `Bijection` use this longer form constructor:
```
Bijection{K, V, IdDict{K,V}, IdDict{V,K}}()
```
where `K` is the type of the keys and `V` is the type of the values. 

For example:
```
julia> b = Bijection{Vector{Int}, String, IdDict{Vector{Int},String}, IdDict{String,Vector{Int}}}()
Bijection{Vector{Int64}, String, IdDict{Vector{Int64}, String}, IdDict{String, Vector{Int64}}}()

julia> b[ [1,2,3] ] = "alpha"
"alpha"

julia> b[ [1,2,3] ] = "beta"
"beta"

julia> b("alpha") == b("beta")
true

julia> b("alpha") === b("beta")
false
```