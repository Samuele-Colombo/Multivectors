@enum Scalar begin
    ŝ = Int32(1)
end

Base.:*(s::Real, ::Scalar) = s 

show(io::IO, ::MIME"text/plain", a::Scalar) = show(io, a)
show(io::IO, ::Scalar) = show(io, "")

@enum PseudoScalar3D begin
    x̂ŷẑ = Int32(8)
end

const ı̂ = x̂ŷẑ 

Base.:*(s::Real, ::PseudoScalar3D) = Complex(0, s) 

const UVecs3D = Union{Scalar, VectorBasis3D, PseudoVectorBasis3D, PseudoScalar3D}

const _uvecs = vcat(instances(Scalar)..., 
                    instances(VectorBasis3D)..., 
                    instances(PseudoVectorBasis3D)..., 
                    instances(PseudoScalar3D)...)

struct MultiVector3D{T} <: FieldVector{8, T}
    ŝ::T
    x̂::T
    ŷ::T
    ẑ::T
    x̂ŷ::T
    x̂ẑ::T
    ŷẑ::T
    x̂ŷẑ::T
end

show(io::IO, ::MIME"text/plain", a::MultiVector3D) = show(io, a)
function show(io::IO, a::MultiVector3D)
    compact = get(io, :compact, false)
    vec = [zip(a, _uvecs)...][map(!iszero, a)]
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
