@enum VectorBasis3D begin 
    x̂ = Int32(2) 
    ŷ
    ẑ
end

struct Vector3D{T} <: FieldVector{3, T}
    x̂::T
    ŷ::T
    ẑ::T
end

Base.:*(s::Real, b::VectorBasis3D) =  s * [i ≠ b ? 0 : 1 for i ∈ instances(VectorBasis3D)] |> Vector3D

function getindex(v::Vector3D{T}, i::Int64) where {T}
    i ∈ Int32.(_uvecs)                   || throw(BoundsError(v, i))
    i ∈ Int32.(instances(VectorBasis3D)) || return zero(T)
    getfield(v, i |> VectorBasis3D |> Symbol)
end

getindex(v::Vector3D, i::UVecs3D) = getindex(v, Int64(i))

function iterate(v::Vector3D, base::Int64 = 1)
    base <= length(v) ? (getindex(v, base), base + 1) : nothing
end

length(::Vector3D) = length(_uvecs)

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