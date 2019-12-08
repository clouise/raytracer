mutable struct Sphere
    id::Int
    transform::SArray
    material::Material
end

function setTransform(s::Sphere, m::SArray)
    s.transform = m
end

function Sphere()
    global inc += 1
    return(Sphere(inc, SA_F64[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1], Material()))
end

function normal_at(sphere::Sphere, p::svec)
    # first we convert from the world point
    # to the point in object space by inversing the transform
    object_point = inv(sphere.transform) * p
    object_normal = object_point - point(0, 0, 0)
    # to return back to world space we have to transpose after taking the inverse?
    # TODO: figure out why
    world_normal = inv(sphere.transform)' * object_normal
    world_normal[4] = 0.0
    return normalise(world_normal)
end
