module RayTracer

export point, vector, color, magnitude, normalise
export Canvas, writePixel, canvasToPPM
export Intersection, Intersections, push!, hit, reflect
export PointLight
export Material, lighting
export Ray, transform, position, intersect
export Sphere, setTransform, normal_at
export translation, scaling, rotationX, rotationY, rotationZ, shearing

using StaticArrays
using BenchmarkTools
using LinearAlgebra

import Base.push!
import Base.intersect
import Base.position

include("./helpers.jl")
include("./material.jl")
include("./sphere.jl")
include("./canvas.jl")
include("./transformations.jl")
include("./rays.jl")
include("./light.jl")
include("./intersections.jl")

end #module
