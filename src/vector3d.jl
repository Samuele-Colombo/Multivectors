@enum VectorBasis3D begin 
    x̂ = Int32(1) 
    ŷ
    ẑ
end

struct Vector3D{T} <: FieldVector{3, T}
    x̂::T
    ŷ::T
    ẑ::T
end

Base.:*(s::Number, b::VectorBasis3D) =  s * [i ≠ Int(b) ? 0 : 1 for i ∈ 1:3] |> Vector3D

norm²(v::Vector3D) = sum(el -> el^2, v.svec)

show(io::IO, ::MIME"text/plain", a::Vector3D) = show(io, a)
function show(io::IO, a::Vector3D)
    compact = get(io, :compact, false)
    vec = [zip(a, instances(VectorBasis3D))...][map(!iszero, a)]
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