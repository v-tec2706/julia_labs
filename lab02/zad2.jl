import Base.*
import Base.convert
import Base.promote_rule

struct G{N}
    x::Number
    G{N}(x) where {N} = new(ifOkMember(x,N) ? x : ConvToOkMember(x,N))
end

function ifOkMember(x,N)
    if (x<N)
        if(gcd(x,N) != 1)
            throw(DomainError())
        else true
        end
    else false
    end
end

function ConvToOkMember(x,N)
    newX=x%N
    if(ifOkMember(newX,N) == true)
        newX=newX
    end
    return newX
end

*(a::G{N},b::G{N}) where {N} = a.x*b.x
*(a::G{N},b::Type{T}) where {N,T<:Integer} = a.x*b
*(a::Type{T},b::G{N}) where {N,T<:Integer} = a*b.x

convert(::Type{G{N}},x::Int64) where{N} = G{N}(x)
convert(::Type{Int64},x::G{N}) where{N} = x.x

promote_rule(::Type{G{N}},::Type{T}) where{N,T<:Integer} = G{N}

function myMod(a::G{N},x::T) where {N,T<:Integer}
    i=1
    for j=1:x
        i*=a.x%N
    end
    return i
end

function myPeriod(a::G{N}) where {N}
    r=1;
    while a.x^r%N != 1
        r+=1
    end
    return r
end

function inverseElem(a::G{N}) where {N}
    r=1;
    while a.x*r%N != 1
        r+=1
    end
    return r
end

function isInGroup(x,N)
    if(x<N)
        x=x%N
    end
    if(gcd(x,N) == 1)
        true
    else false
    end
end


function countElem(::Type{G{N}}) where{N}
    return length(filter(x->isInGroup(x,N),1:N))
end


###### tests
g1 = G{5}(3)
#println(g1.x)
#g2 = G{5}(7)
#println(g2.x)
#*(4,g1)
#convert(G{5},9)
#convert(Int64,g2)

promote_type(G{78},Int64)
#countElem(G{5})
#myPeriod(G{1000}(7))
