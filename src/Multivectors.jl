module Multivectors

import Base:
    (*), (+),
    show, iterate, getindex, length
import StaticArrays:
    FieldVector

export Vector3D, norm²,
    Scalar, ŝ,
    VectorBasis3D, x̂, ŷ, ẑ,
    PseudoVectorBasis3D, x̂ŷ, x̂ẑ, ŷẑ,
    PseudoScalar3D, x̂ŷẑ, ı̂

include("bases.jl")
include("multivector3d.jl")

end # module
