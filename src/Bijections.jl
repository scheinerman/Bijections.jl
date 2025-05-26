module Bijections

import Base:
    *,
    ==,
    collect,
    delete!,
    display,
    getindex,
    inv,
    isempty,
    iterate,
    length,
    setindex!,
    show

export Bijection,
    active_inv,
    collect,
    display,
    domain,
    getindex,
    image,
    inverse,
    isempty,
    length,
    setindex!,
    show

struct Bijection{S,T} <: AbstractDict{S,T}
    f::Dict{S,T}       # map from domain to range
    finv::Dict{T,S}    # inverse map from range to domain

    # standard constructor
    function Bijection{S,T}() where {S,T}
        F = Dict{S,T}()
        G = Dict{T,S}()
        new(F, G)
    end

    # private, unsafe constructor
    function Bijection{S,T}(F::Dict{S,T}, G::Dict{T,S}) where {S,T}
        new(F, G)
    end
end

# Default constructor is a bijection from Any to Any
"""
    Bijection()

Construct a new `Bijection`. 

* `Bijection{S,T}()` creates an empty `Bijection` from objects of type `S` to objects of type `T`. If `S` and `T` are omitted, then we have `Bijection{Any,Any}`.
* `Bijection(x::S, y::T)` creates a new `Bijection` initialized with `x` mapping to `y`.
* `Bijection(dict::Dict{S,T})` creates a new `Bijection` based on the mapping in `dict`. 
* `Bijection(pair_list::Vector{Pair{S,T}})` creates a new `Bijection` using the key/value pairs in `pair_list`. 
"""
function Bijection()
    Bijection{Any,Any}()
end

# Create a new bijection given two values to start off. Domain and
# range types are inferred from x and y.
function Bijection(x::S, y::T) where {S,T}
    b = Bijection{S,T}()
    b[x] = y
    return b
end

# Convert an `AbstractDict` to a `Bijection`
function Bijection(dict::AbstractDict{S,T}) where {S,T}
    vals = values(dict)
    if length(dict) != length(unique(vals))
        error("Repeated value found in dict")
    end

    b = Bijection{S,T}()
    for (k, v) in pairs(dict)
        b[k] = v
    end
    return b
end

# Copy constructor
Bijection(b::Bijection) = Bijection(collect(b))

## Convert a list of pairs to a Bijection
function Bijection(pair_list::Vector{Pair{S,T}}) where {S,T}
    p = unique(pair_list)  # remove duplicate pairs
    n = length(p)

    xs = first.(p)
    ys = last.(p)
    if length(xs) != length(unique(xs)) || length(ys) != length(unique(ys))
        error("Repeated key or value found in pair list")
    end

    b = Bijection{S,T}()
    for xy in p
        x, y = xy
        b[x] = y
    end
    return b
end

# Decent way to print out a bijection
function show(io::IO, b::Bijection{S,T}) where {S,T}
    print(io, "Bijection{$S,$T} (with $(length(b)) pairs)")
end

# equality checking
==(a::Bijection, b::Bijection) = a.f == b.f

# Add a relation to a bijection: b[x] = y
"""
    setindex!(b::Bijection, y, x)

For a `Bijection` `b` use the syntax `b[x]=y` to add `(x,y)` to `b`.
"""
function setindex!(b::Bijection, y, x)
    if in(x, domain(b)) || in(y, image(b))
        error("One of x or y already in this Bijection")
    else
        b.f[x] = y
        b.finv[y] = x
    end
    b
end

# retreive b[x] where x is in domain
"""
    getindex(b::Bijection, x)

For a `Bijection` `b` and a value `x` in its domain, use `b[x]` to
fetch the image value `y` associated with `x`.
"""
function getindex(b::Bijection, x)
    b.f[x]
end

# apply the inverse mapping (from range to domain) to an element y
"""
    inverse(b::Bijection, y)

Returns the value `x` such that `b[x] == y`
(if it exists).
"""
function inverse(b::Bijection, y)
    b.finv[y]
end

# the notation b(y) is a shortcut for inverse(b,y)
(b::Bijection)(y) = inverse(b, y)

# Remove a pair (x,y) from a bijection
"""
    delete!(b::Bijection, x)

Deletes the ordered pair `(x,b[x])` from `b`.
"""
function delete!(b::Bijection, x)
    y = b[x]
    delete!(b.f, x)
    delete!(b.finv, y)
    return b
end

# Give the number of pairs in this bijection
"""
    length(b::Bijection)

Gives the number of ordered pairs in `b`.
"""
function length(b::Bijection)
    length(b.f)
end

# Check if this bijection is empty
"""
    isempty(b::Bijection)

Returns true iff `b` has no pairs.
"""
function isempty(b::Bijection)
    length(b.f) == 0
end

# convert a bijection into an array of ordered pairs. This is
# compatible with what collect does for Dict's.
collect(b::Bijection) = collect(b.f)

# return the domain as an array of values
"""
    domain(b::Bijection)

Returns an iterator for the keys for `b`.
"""
domain(b::Bijection) = keys(b)

# return the image as an array of values
"""
    image(b::Bijection)

Returns an iterator for the values of `b`.
"""
image(b::Bijection) = values(b)

iterate(b::Bijection{S,T}, s::Int) where {S,T} = iterate(b.f, s)
iterate(b::Bijection{S,T}) where {S,T} = iterate(b.f)

# convert a Bijection into a Dict; probably not useful 
Base.Dict(b::Bijection) = copy(b.f)

"""
    get(b::Bijection, key, default)

Returns `b[key]` if it exists and returns `default` otherwise.
"""
function get(b::Bijection, key, default)
    get(b.f, key, default)
end

include("inversion.jl")
include("composition.jl")

end # end of module Bijections
