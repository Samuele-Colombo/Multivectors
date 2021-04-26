@enum PseudoVectorBasis3D begin 
    x̂ŷ = Int32(4)
    ŷẑ
    x̂ẑ
end

struct PseudoVector3D{T} <: FieldVector{3, T}
    x̂ŷ::T
    x̂ẑ::T
    ŷẑ::T
end

Base.:*(s::Number, b::PseudoVectorBasis3D) =  s * [i ≠ Int(b) ? 0 : 1 for i ∈ 4:6] |> PseudoVector3D

show(io::IO, ::MIME"text/plain", a::PseudoVector3D) = show(io, a)
function show(io::IO, a::PseudoVector3D)
    compact = get(io, :compact, false)
    vec = [zip(a, instances(PseudoVectorBasis3D))...][map(!iszero, a)]
    isempty(vec) && return
    coord, uv = vec[begin]
    show(io, coord); show(io, uv)
    
    for (coord, uv) ∈ vec[begin+1:end]
        iszero(coord) && continue
        if signbit(coord) && !isnan(coord)
            print(io, compact ? "-" : " - ")
            if isa(coord,Signed) && !isa(coord,BigInt) && coord == typemin(typeof(coord))
                show(io, -widen(coord))
            else
                show(io, -coord)
            end
        else
            print(io, compact ? "+" : " + ")
            show(io, coord)
        end
        if !(isa(coord,Integer) && !isa(coord,Bool) || isa(coord,AbstractFloat) && isfinite(coord))
            print(io, "*")
        end
        print(io, uv)
    end    
end