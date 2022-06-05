module Bijections

import Base: delete!, length, isempty, collect, setindex!, getindex, get
import Base: show, display, ==, iterate

# import Base.isempty, Base.collect, Base.setindex!, Base.getindex
# import Base.show, Base.display, Base.==

export Bijection, setindex!, getindex, inverse, length
export isempty, collect, domain, image, show, display

struct Bijection{S,T} <: AbstractDict{S,T}
    domain::Set{S}     # domain of the bijection
    range::Set{T}      # range of the bijection
    f::Dict{S,T}       # map from domain to range
    finv::Dict{T,S}    # inverse map from range to domain

    # standard constructor
    function Bijection{S,T}() where {S,T}
        D = Set{S}()
        R = Set{T}()
        F = Dict{S,T}()
        G = Dict{T,S}()
        new(D,R,F,G)
    end

    # private, unsafe constructor
    function Bijection{S,T}(D::Set{S},R::Set{T},F::Dict{S,T},G::Dict{T,S}) where {S,T}
        new(D,R,F,G)
    end
end

# Default constructor is a bijection from Any to Any
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
function Bijection(dict::AbstractDict{S, T}) where S where T
    b = Bijection{S,T}()
    for (k, v) in pairs(dict)
        b[k] = v
    end
    return b
end
Bijection(b::Bijection) = b

# Decent way to print out a bijection
function show(io::IO,b::Bijection{S,T}) where {S,T}
    print(io,"Bijection{$S,$T} (with $(length(b)) pairs)")
end

display(b::Bijection) = (print("Bijection "); display(b.f))

# equality checking
==(a::Bijection, b::Bijection) = a.f == b.f


# Add a relation to a bijection: b[x] = y
"""
For a `Bijection` `b` use the syntax `b[x]=y` to add `(x,y)` to `b`.
"""
function setindex!(b::Bijection, y, x)
    if in(x,b.domain) || in(y,b.range)
        error("One of x or y already in this Bijection")
    else
        push!(b.domain,x)
        push!(b.range,y)
        b.f[x] = y
        b.finv[y] = x
    end
    b
end

# retreive b[x] where x is in domain
"""
For a `Bijection` `b` and a value `x` in its domain, use `b[x]` to
fetch the image value `y` associated with `x`.
"""
function getindex(b::Bijection, x)
    b.f[x]
end

# apply the inverse mapping (from range to domain) to an element y
"""
`inverse(b::Bijection,y)` returns the value `x` such that `b[x] == y`
(if it exists).
"""
function inverse(b::Bijection, y)
    b.finv[y]
end

# the notation b(y) is a shortcut for inverse(b,y)
"""
For a `Bijection` `b` we may use `b(y)` to return the value
`x` such that `b[x]==y`. In other words, this is a short cut
for `inverse(b,y)`.
"""
(b::Bijection)(y) = inverse(b,y)


# Remove a pair (x,y) from a bijection
"""
`delete!(b::Bijection,x)` deletes the ordered pair `(x,b[x])` from `b`.
"""
function delete!(b::Bijection, x)
    y = b[x]
    delete!(b.domain,x)
    delete!(b.range,y)
    delete!(b.f, x)
    delete!(b.finv, y)
    return b
end

# Give the number of pairs in this bijection
"""
`length(b::Bijection)` gives the number of ordered pairs in `b`.
"""
function length(b::Bijection)
    length(b.domain)
end

# Check if this bijection is empty
"""
`isempty(b::Bijection)` returns true iff `b` has no pairs.
"""
function isempty(b::Bijection)
    length(b) == 0
end

# convert a bijection into an array of ordered pairs. This is
# compatible with what collect does for Dict's.
collect(b::Bijection) = collect(b.f)

# return the domain as an array of values
"""
`domain(b::Bijection)` returns the set of input values for `b`.
"""
domain(b::Bijection) = copy(b.domain)

# return the image as an array of values
"""
`image(b::Bijection)` returns the set of output values of `b`.
"""
image(b::Bijection) = copy(b.range)


iterate(b::Bijection{S,T},s::Int) where {S,T} = iterate(b.f,s)
iterate(b::Bijection{S,T}) where {S,T} = iterate(b.f)

# convert a Bijection into a Dict; probably not useful 
Dict(b::Bijection) = copy(b.f)


# Check if this bijection is empty
"""
`get(b::Bijection, key, default)` returns b[key] if it exists and returns default otherwise.
"""
function get(b::Bijection, key, default)
    get(b.f, key, default)
end

include("inversion.jl")

end # end of module Bijections
