# Module written by Ed Scheinerman, ers@jhu.edu
# distributed under terms of the MIT license

module Bijections

import Base.delete!, Base.length
import Base.isempty, Base.collect, Base.setindex!, Base.getindex
import Base.show, Base.display

export Bijection, setindex!, getindex, inverse, length
export isempty, collect, domain, image, show, display

type Bijection{S,T} <: Associative{S,T}
    domain::Set{S}     # domain of the bijection
    range::Set{T}      # range of the bijection
    f::Dict{S,T}       # map from domain to range
    finv::Dict{T,S}    # inverse map from range to domain
    function Bijection()
        D = Set{S}()
        R = Set{T}()
        F = Dict{S,T}()
        G = Dict{T,S}()
        new(D,R,F,G)
    end
end

# Default constructor is a bijection from Any to Any
function Bijection()
    Bijection{Any,Any}()
end


# Create a new bijection given two values to start off. Domain and
# range types are inferred from x and y.
function Bijection{S,T}(x::S, y::T)
    b = Bijection{S,T}()
    b[x] = y
    return b
end

# Decent way to print out a bijection
function show(io::IO,b::Bijection)
    print(io,"Bijection (with $(length(b)) pairs)")
end

display(b::Bijection) = show(b)

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

# convert a bijection into an array of ordered pairs
"""
`collect(b::Bijection)` presents the bijection as a list of ordered pairs.
"""
function collect(b::Bijection)
    [ (x, b[x]) for x in b.domain ]
end

# return the domain as an array of values
"""
`domain(b::Bijection)` returns the list of input values for `b`.
"""
function domain(b::Bijection)
    collect(b.domain)
end

# return the image as an array of values
"""
`image(b::Bijection)` returns the list of output values of `b`.
"""
function image(b::Bijection)
    collect(b.range)
end

end # end of module Bijections
