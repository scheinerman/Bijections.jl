# Module written by Ed Scheinerman, ers@jhu.edu
# distributed under terms of the MIT license

module Bijections

import Base.show, Base.delete!, Base.length
import Base.isempty, Base.collect

export Bijection, show, setindex!, getindex, inverse, length
export isempty, collect, domain, range

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
    print(io,"$(typeof(b)) (with $(length(b)) pairs)")
end
        
# Add a relation to a bijection: b[x] = y
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
function getindex(b::Bijection, x)
    b.f[x]
end

# apply the inverse mapping (from range to domain) to an element y
function inverse(b::Bijection, y)
    b.finv[y]
end

# Remove a pair (x,y) from a bijection
function delete!(b::Bijection, x)
    y = b[x]
    delete!(b.domain,x)
    delete!(b.range,y)
    delete!(b.f, x)
    delete!(b.finv, y)
    return b
end

# Give the number of pairs in this bijection
function length(b::Bijection)
    length(b.domain)
end

# Check if this bijection is empty
function isempty(b::Bijection)
    length(b) == 0
end

# convert a bijection into an array of ordered pairs
function collect(b::Bijection)
    [ (x, b[x]) for x in b.domain ]
end

# return the domain as an array of values
function domain(b::Bijection)
    collect(b.domain)
end

# return the range as an array of values
function range(b::Bijection)
    collect(b.range)
end

end # end of module Bijections
