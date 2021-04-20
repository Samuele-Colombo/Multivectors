module Multivectors

import Base:
    (*), show
import StaticArrays:
    FieldVector

export VectorBasis3D, Vector3D, norm²,
    x̂, ŷ, ẑ

include("vector3d.jl")

end # module
