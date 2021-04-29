struct Vector3D{T} <: FieldVector{3, T}
    x̂::T
    ŷ::T
    ẑ::T
end

Vector3D(x, y, z) = Vector3D(promote(x, y, z)...)

struct PseudoVector3D{T} <: FieldVector{3, T}
    x̂ŷ::T
    x̂ẑ::T
    ŷẑ::T
end

PseudoVector3D(xy, xz, yz) = PseudoVector3D(promote(xy, xz, yz)...)

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

MultiVector3D(s, x, y, z, xy, xz, yz, xyz) = MultiVector3D(promote(s, x, y, z, xy, xz, yz, xyz)...)

Base.:*(s::T, ::Scalar) where {T <: Real}         = MultiVector3D(s, zeros(T, 7)...) 
Base.:*(s::Real, b::VectorBasis3D)                =       Vector3D((i ≠ b ? false : s for i ∈ instances(VectorBasis3D))...)
Base.:*(s::Real, b::PseudoVectorBasis3D)          = PseudoVector3D((i ≠ b ? false : s for i ∈ instances(PseudoVectorBasis3D))...)
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

@inline function _apply(f::Function, mv::MultiVector3D, v::Union{Vector3D, PseudoVector3D}, range::AbstractVector)
    arr = mv |> SVector{8}
    arr[range] = f(@view(arr[range]), v)
    arr |> MultiVector3D
end

@inline function _apply(f::Function, mv::MultiVector3D, z::Complex, range::AbstractVector)
    arr = mv |> SVector{8}
    arr[range] = f(@view(arr[range]), reim(z) |> SVector{2})
    arr |> MultiVector3D
end

@inline function _apply(f::Function, mv::MultiVector3D, r::Real, i::Int)
    arr = mv |> SVector{8}
    arr[i] = f(arr[i], r)
    arr |> MultiVector3D
end

+(mv::MultiVector3D, v::Vector3D) = _apply(+, mv, v, 2:4) 
-(mv::MultiVector3D, v::Vector3D) = _apply(-, mv, v, 2:4) 

+(mv::MultiVector3D, v::PseudoVector3D) = _apply(+, mv, v, 5:7) 
-(mv::MultiVector3D, v::PseudoVector3D) = _apply(-, mv, v, 5:7) 

+(mv::MultiVector3D, r::Real) = _apply(+, mv, r, mv |> firstindex) 
-(mv::MultiVector3D, r::Real) = _apply(-, mv, r, mv |> firstindex) 

+(mv::MultiVector3D, z::Complex) = _apply(+, mv, z, mv .|> [firstindex, lastindex]) 
-(mv::MultiVector3D, z::Complex) = _apply(-, mv, z, mv .|> [firstindex, lastindex]) 

+(v::Union{Real, Complex, Vector3D, PseudoVector3D}, mv::MultiVector3D) = +(mv, v)
-(v::Union{Real, Complex, Vector3D, PseudoVector3D}, mv::MultiVector3D) = -(mv, v)

+(v::Vector3D, pv::PseudoVector3D) = [false, v...,  pv..., false] |> MultiVector3D 
-(v::Vector3D, pv::PseudoVector3D) = [false, v..., -pv..., false] |> MultiVector3D 

+(v::Vector3D, r::Real) = [ r, v..., zeros(Bool, 4)...] |> MultiVector3D 
-(v::Vector3D, r::Real) = [-r, v..., zeros(Bool, 4)...] |> MultiVector3D 

+(v::Vector3D, z::Complex) = [ real(z), v..., zeros(Bool, 3)...,  imag(z)] |> MultiVector3D 
-(v::Vector3D, z::Complex) = [-real(z), v..., zeros(Bool, 3)..., -imag(z)] |> MultiVector3D 

@inline +(vv::Union{PseudoVector3D, Real, Complex}, v::Vector3D) = +(v, vv)
@inline -(vv::Union{PseudoVector3D, Real, Complex}, v::Vector3D) = -(v, vv)

+(pv::PseudoVector3D, r::Real) = [ r, zeros(Bool, 3)..., pv..., false] |> MultiVector3D 
-(pv::PseudoVector3D, r::Real) = [-r, zeros(Bool, 3)..., pv..., false] |> MultiVector3D 

+(pv::PseudoVector3D, z::Complex) = [ real(z), zeros(Bool, 3)..., pv...,  imag(z)] |> MultiVector3D 
-(pv::PseudoVector3D, z::Complex) = [-real(z), zeros(Bool, 3)..., pv..., -imag(z)] |> MultiVector3D 

@inline +(v::Union{Real, Complex}, pv::PseudoVector3D) = +( pv, v)
@inline -(v::Union{Real, Complex}, pv::PseudoVector3D) = +(-pv, v)

@inline +(v1::Union{MultiVector3D, Vector3D, PseudoVector3D, Real, Complex}, 
          v2::Union{MultiVector3D, Vector3D, PseudoVector3D, Real, Complex}, 
          vs::Union{MultiVector3D, Vector3D, PseudoVector3D, Real, Complex}...) = v1 + +(v2, vs...)
@inline -(v1::Union{MultiVector3D, Vector3D, PseudoVector3D, Real, Complex}, 
          v2::Union{MultiVector3D, Vector3D, PseudoVector3D, Real, Complex}, 
          vs::Union{MultiVector3D, Vector3D, PseudoVector3D, Real, Complex}...) = v1 - +(v2, vs...)
