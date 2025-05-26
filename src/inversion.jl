"""
`inv(b::Bijection)` creates a new `Bijection` that is the
inverse of `b`.
Subsequence changes to `b` will not affect `inv(b)`.

See also `active_inv`.
"""
function inv(b::Bijection{S,T}) where {S,T}
    bb = Bijection{T,S}()
    for (x, y) in b
        bb[y] = x
    end
    return bb
end

"""
`active_inv(b::Bijection)` creates a `Bijection` that is the
inverse of `b`. The original `b` and the new `Bijection` returned
are tied together so that changes to one immediately affect the
other. In this way, the two `Bijection`s remain inverses in
perpetuity.

See also `inv`.
"""
function active_inv(b::Bijection{S,T}) where {S,T}
    return Bijection{T,S}(b.finv, b.f)
end
