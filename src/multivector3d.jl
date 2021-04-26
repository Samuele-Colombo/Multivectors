struct Vector3D{T} <: FieldVector{3, T}
    x̂::T
    ŷ::T
    ẑ::T
end

struct PseudoVector3D{T} <: FieldVector{3, T}
    x̂ŷ::T
    x̂ẑ::T
    ŷẑ::T
end

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

Base.:*(s::T, ::Scalar) where {T <: Real}         = MultiVector3D(s, zeros(T, 7)...) 
Base.:*(s::Real, b::VectorBasis3D)                =       Vector3D((i ≠ b ? 0 : s for i ∈ instances(VectorBasis3D))...)
Base.:*(s::Real, b::PseudoVectorBasis3D)          = PseudoVector3D((i ≠ b ? 0 : s for i ∈ instances(PseudoVectorBasis3D))...)
Base.:*(s::T, ::PseudoScalar3D) where {T <: Real} = MultiVector3D(zeros(T, 7)..., s)

for (Type, basis) ∈ [:Vector3D => instances(VectorBasis3D), :PseudoVector3D => instances(PseudoVectorBasis3D), :MultiVector3D => _uvecs]
    quote
        show(io::IO, ::MIME"text/plain", a::$Type) = show(io, a)
        function show(io::IO, a::$Type)
            compact = get(io, :compact, false)
            vec = [zip(a, $basis)...][map(!iszero, a)]
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
    end |> eval
end




