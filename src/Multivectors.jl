module Multivectors

import Base:
    (*), show
import StaticArrays:
    FieldVector

export Vector3D, norm²,
    VectorBasis3D, x̂, ŷ, ẑ,
    PseudoVectorBasis3D, x̂ŷ, x̂ẑ, ŷẑ

include("vector3d.jl")
include("pseudovector3d.jl")

end # module
