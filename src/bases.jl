@enum Scalar begin
    ŝ = Int32(1)
end

show(io::IO, ::MIME"text/plain", a::Scalar) = show(io, a)
show(::IO, ::Scalar) = return

@enum VectorBasis3D begin 
    x̂ = Int32(2) 
    ŷ
    ẑ
end

@enum PseudoVectorBasis3D begin 
    x̂ŷ = Int32(5)
    ŷẑ
    x̂ẑ
end

@enum PseudoScalar3D begin
    x̂ŷẑ = Int32(8)
end

const ı̂ = x̂ŷẑ 

const UVecs3D = Union{Scalar, VectorBasis3D, PseudoVectorBasis3D, PseudoScalar3D}

const _uvecs = vcat(instances(Scalar)..., 
                    instances(VectorBasis3D)..., 
                    instances(PseudoVectorBasis3D)..., 
                    instances(PseudoScalar3D)...)