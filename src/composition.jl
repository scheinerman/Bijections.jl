"""
    (*)(a::Bijection{A,B}, b::Bijection{B,C})::Bijection{A,C} where {A,B,C}

The result of `a * b` is a new `Bijection` `c` such that `c[x]` is `a[b[x]]` for `x`
in the domain of `b`.
"""
function Base.:(*)(a::Bijection{B,A}, b::Bijection{C,B}) where {A,B,C}
    c = Bijection{C,A}()
    for x in keys(b)
        c[x] = a[b[x]]
    end
    return c
end
