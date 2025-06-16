module Bijections

using Serialization: Serialization

export Bijection, active_inv, inverse, hasvalue, compose

struct Bijection{K,V,F,Finv} <: AbstractDict{K,V}
    f::F          # map from domain to range
    finv::Finv    # inverse map from range to domain

    function Bijection(
        f::F, finv::Finv
    ) where {K,V,F<:AbstractDict{K,V},Finv<:AbstractDict{V,K}}
        return new{K,V,F,Finv}(f, finv)
    end

    function Bijection{K,V,F,Finv}(
        f::F, finv::Finv
    ) where {K,V,F<:AbstractDict{K,V},Finv<:AbstractDict{V,K}}
        return new{K,V,F,Finv}(f, finv)
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
Bijection() = Bijection{Any,Any}()

# Create a new bijection given two values to start off. Domain and
# range types are inferred from x and y.
function Bijection(x::S, y::T) where {S,T}
    b = Bijection{S,T}()
    b[x] = y
    return b
end

# F, Finv default to `Dict{K,V}` and `Dict{V,K}` respectively
function Bijection{K,V}(args...; kwargs...) where {K,V}
    return Bijection{K,V,Dict{K,V},Dict{V,K}}(args...; kwargs...)
end

# Convert an `AbstractDict` to a `Bijection`
Bijection(f::F) where {F<:AbstractDict} = Bijection(f, dict_inverse(f))

function Bijection{K,V,F,Finv}(
    f::F
) where {K,V,F<:AbstractDict{K,V},Finv<:AbstractDict{V,K}}
    return Bijection{K,V,F,Finv}(f, Finv(Iterators.map(reverse, f)))
end

# Copy constructor
Bijection(b::Bijection) = Bijection(copy(b.f), copy(b.finv))

# if not defined, it will just return a copy of `b.f`
Base.copy(b::Bijection) = Bijection(copy(b.f), copy(b.finv))

# Convert a list of pairs to a Bijection (already contains empty constructor)
function Bijection{K,V,F,Finv}(pairs::Pair...) where {K,V,F,Finv}
    return Bijection{K,V,F,Finv}(F(pairs...), Finv(Iterators.map(reverse, pairs)))
end

function Bijection{K,V,F,Finv}(pairs::Vector) where {K,V,F,Finv}
    return Bijection{K,V,F,Finv}(F(pairs...), Finv(Iterators.map(reverse, pairs)))
end

# shortcuts for creating a Bijection from a list of pairs
Bijection(pairs::Pair...) = Bijection(Dict(pairs...), Dict(Iterators.map(reverse, pairs)))
Bijection(pairs::Vector) = Bijection(Dict(pairs...), Dict(Iterators.map(reverse, pairs)))

# create a Bijection of same type but no entries
function Base.empty(b::Bijection, ::Type{K}, ::Type{V}) where {K,V}
    return Bijection(empty(b.f, K, V), empty(b.finv, V, K))
end

# equality checking
Base.:(==)(a::Bijection, b::Bijection) = a.f == b.f

"""
    Base.haskey(b::Bijection, x)

Checks if `x` is in the domain of the Bijection `b`.`
"""
Base.haskey(b::Bijection, x) = haskey(b.f, x)

"""
    hasvalue(b::Bijection, y)

Checks if `y` is in the image of the Bijection `b`. It is equivalent to checking if the inverse mapping `b.finv` has `y` as a key, so it should as fast as `haskey`.
"""
hasvalue(b::Bijection, y) = haskey(b.finv, y)

# Add a relation to a bijection: b[x] = y
"""
    setindex!(b::Bijection, y, x)

For a `Bijection` `b` use the syntax `b[x]=y` to add `(x,y)` to `b`.
"""
function Base.setindex!(b::Bijection, y, x)
    haskey(b.finv, y) &&
        throw(ArgumentError("inserting $x => $y would break bijectiveness"))

    # if update of existing key, then remove old value from finv
    # TODO test this!!
    if haskey(b.f, x)
        old_y = b.f[x]
        delete!(b.finv, old_y)
    end

    b.f[x] = y
    b.finv[y] = x

    return b
end

# retreive b[x] where x is in domain
"""
    getindex(b::Bijection, x)

For a `Bijection` `b` and a value `x` in its domain, use `b[x]` to
fetch the image value `y` associated with `x`.
"""
Base.getindex(b::Bijection, x) = b.f[x]

# apply the inverse mapping (from range to domain) to an element y
"""
    inverse(b::Bijection, y)

Returns the value `x` such that `b[x] == y`
(if it exists).
"""
inverse(b::Bijection, y) = b.finv[y]

# the notation b(y) is a shortcut for inverse(b,y)
(b::Bijection)(y) = inverse(b, y)

# WARN this uses internals so it's dangerous! do not make it public
# this is just used for the default case, but in general the method should be extended for new `AbstractDict` types
"""
    inverse_dict_type(D::Type{<:AbstractDict})

Returns the type of the inverse dictionary for a given `AbstractDict` type `D`.
This is used internally to create the inverse mapping in a `Bijection`.
"""
function inverse_dict_type(D::Type{<:AbstractDict{K,V}}) where {K,V}
    @warn "Using the default `inverse_dict_type` for $D. This may not be optimal for your specific dictionary type."
    return D.name.wrapper{V,K}
end

inverse_dict_type(::Type{Dict{K,V}}) where {K,V} = Dict{V,K}
inverse_dict_type(::Type{IdDict{K,V}}) where {K,V} = IdDict{V,K}
inverse_dict_type(::Type{Base.ImmutableDict{K,V}}) where {K,V} = Base.ImmutableDict{V,K}

# PersistentDict was introduced in Julia 1.11
if isdefined(Base, :PersistentDict)
    function inverse_dict_type(::Type{Base.PersistentDict{K,V}}) where {K,V}
        return Base.PersistentDict{V,K}
    end
end

function dict_inverse(d::D) where {D<:AbstractDict}
    allunique(values(d)) || throw(ArgumentError("dict is not bijective"))
    return inverse_dict_type(D)(reverse.(collect(d)))
end

function dict_inverse(d::Base.ImmutableDict{K,V}) where {K,V}
    # ImmutableDict does not have a ImmutableDict{K,V}(pairs...) constructor
    # The version of the constructor with type parameters was overlooked in
    # https://github.com/JuliaLang/julia/issues/35863
    d_inv = Base.ImmutableDict{V,K}()
    for (k, v) in reverse.(collect(d))
        d_inv = Base.ImmutableDict{V,K}(d_inv, k, v)
    end
    return d_inv
end

"""
    inv(b::Bijection)

Creates a new `Bijection` that is the inverse of `b`.
Subsequence changes to `b` will not affect `inv(b)`.

See also [`active_inv`](@ref).
"""
Base.inv(b::Bijection) = copy(active_inv(b))

"""
    active_inv(b::Bijection)

Creates a `Bijection` that is the inverse of `b`.
The original `b` and the new `Bijection` returned are tied together so that changes to one immediately affect the other.
In this way, the two `Bijection`s remain inverses in perpetuity.

See also [`inv`](@ref).
"""
active_inv(b::Bijection) = Bijection(b.finv, b.f)

# Remove a pair (x,y) from a bijection
"""
    delete!(b::Bijection, x)

Deletes the ordered pair `(x,b[x])` from `b`.
"""
function Base.delete!(b::Bijection, x)
    # replicate `Dict` behavior: if x is not in the domain, do nothing
    haskey(b, x) || return b

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
function Base.length(b::Bijection)
    return length(b.f)
end

# Check if this bijection is empty
"""
    isempty(b::Bijection)

Returns true iff `b` has no pairs.
"""
function Base.isempty(b::Bijection)
    return length(b.f) == 0
end

# convert a bijection into an array of ordered pairs. This is
# compatible with what collect does for Dict's.
Base.collect(b::Bijection) = collect(b.f)

Base.keys(b::Bijection) = keys(b.f)
Base.values(b::Bijection) = values(b.f)

Base.iterate(b::Bijection, s) = iterate(b.f, s)
Base.iterate(b::Bijection) = iterate(b.f)

"""
    get(b::Bijection, key, default)

Returns `b[key]` if it exists and returns `default` otherwise.
"""
Base.get(b::Bijection, key, default) = get(b.f, key, default)

function Base.sizehint!(b::Bijection, sz)
    sizehint!(b.f, sz)
    sizehint!(b.finv, sz)
    return b
end

function Serialization.serialize(
    s::Serialization.AbstractSerializer, b::B
) where {B<:Bijection}
    Serialization.writetag(s.io, Serialization.OBJECT_TAG)

    # serialize type
    Serialization.serialize(s, B)

    # serialize forward dictionary
    return Serialization.serialize(s, b.f)
end

function Serialization.deserialize(
    s::Serialization.AbstractSerializer, ::Type{B}
) where {B<:Bijection}
    f = Serialization.deserialize(s)
    return B(f)
end

# WARN this uses internals so it's dangerous!
"""
    C = composed_dict_type(A::Type{<:AbstractDict}, B::Type{<:AbstractDict})

Returns the type of the forward dictionary of `(a ∘ b)` where `A` and `B` are
the types of the forward-dictionaries of `a` and `b`, respectively.

For any combination of a `IdDict` and a `Dict`, the result will be an `IdDict`.
Otherwise, return `A` with the types of keys and values adjusted so that the
resulting dict maps keys of `b` to values of `a`.
"""
function composed_dict_type(
    A::Type{<:AbstractDict{AK,AV}}, ::Type{<:AbstractDict{BK,BV}}
) where {AK,AV,BK,BV}
    return A.name.wrapper{BK,AV}
end
function composed_dict_type(::Type{Dict{AK,AV}}, ::Type{Dict{BK,BV}}) where {AK,AV,BK,BV}
    Dict{BK,AV}
end
function composed_dict_type(::Type{Dict{AK,AV}}, ::Type{IdDict{BK,BV}}) where {AK,AV,BK,BV}
    IdDict{BK,AV}
end
function composed_dict_type(::Type{IdDict{AK,AV}}, ::Type{Dict{BK,BV}}) where {AK,AV,BK,BV}
    IdDict{BK,AV}
end
function composed_dict_type(
    ::Type{IdDict{AK,AV}}, ::Type{IdDict{BK,BV}}
) where {AK,AV,BK,BV}
    IdDict{BK,AV}
end

"""
    c = (∘)(a::Bijection, b::Bijection)
    c = compose(a, b)

The result of `a ∘ b` or `compose(a, b)` is a new `Bijection` `c` such that
`c[x]` is `a[b[x]]` for `x` in the domain of `b`. The internal type of the
    forward mapping is determined by [`composed_dict_type`](@ref), and the type
    of the backward mapping is determined by [`inverse_dict_type`](@ref).
"""
function compose(
    a::Bijection{AK,AV,AF,AFinv}, b::Bijection{BK,BV,BF,BFinv}
) where {AK,AV,AF,AFinv,BK,BV,BF,BFinv}
    CF = composed_dict_type(AF, BF)
    CFinv = inverse_dict_type(CF)
    c = Bijection{BK,AV,CF,CFinv}()
    for x in keys(b)
        c[x] = a[b[x]]
    end
    return c
end

Base.:(∘)(a::Bijection, b::Bijection) = compose(a, b)

end # end of module Bijections
