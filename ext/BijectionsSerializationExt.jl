module BijectionsSerializationExt

using Bijections
using Serialization

function Serialization.serialize(s::AbstractSerializer, b::B) where {B<:Bijection}
    Serialization.writetag(s.io, Serialization.OBJECT_TAG)

    # serialize type
    serialize(s, B)

    # serialize forward dictionary
    return serialize(s, b.f)
end

function Serialization.deserialize(s::AbstractSerializer, ::Type{B}) where {B<:Bijection}
    f = deserialize(s)
    return b = B(f)
end

end
