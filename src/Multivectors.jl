module Multivectors

import Base:
    (*), (+),
    show, iterate, getindex, length
import StaticArrays:
    FieldVector

export Vector3D, norm²,
    VectorBasis3D, x̂, ŷ, ẑ,
    PseudoVectorBasis3D, x̂ŷ, x̂ẑ, ŷẑ

include("multivector3d.jl")
include("vector3d.jl")
include("pseudovector3d.jl")

end # module
