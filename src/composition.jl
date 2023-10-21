import Base.(*)

"""
    (*)(a::Bijection{A,B}, b::Bijection{B,C})::Bijection{A,C} where {A,B,C}

The result of `a * b` is a new `Bijection` `c` such that `c[x]` is `a[b[x]]` for `x`
in the domain of `b`. This function throws an error is `domain(a)` is not the same 
as the `image` of `b`.    
"""
function (*)(a::Bijection{B,A}, b::Bijection{C,B})::Bijection{C,A} where {A,B,C}
    # check that the domain of a equals the image of B
    if domain(a) != image(b)
        error("Domain/Image mismatch")
    end

    c = Bijection{C,A}()
    for x in domain(b)
        c[x] = a[b[x]]
    end

    return c
end
