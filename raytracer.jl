global inc = 0

svec = MVector{4, Float64}
trans = SMatrix{4, 4, Float64}
vec3 = SVector{3, Float64}


mutable struct sphere
    id::Int
    transform::SArray
end

function setTransform(s::sphere, m::SArray)
    s.transform = m
end

function sphere()
    global inc += 1
    return(sphere(inc, SA_F64[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]))
end

function normal_at(sphere::sphere, p::svec)
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

struct intersection
    t::Float64
    object::Int
end

mutable struct intersections
    count::Int
    array::Vector{intersection}
end

function push!(is::intersections, i::intersection)
    push!(is.array, i)
    is.count += 1
end

point(x, y, z) = svec(Float64(x), Float64(y), Float64(z), 1.0)
vector(x, y, z) = svec(Float64(x), Float64(y), Float64(z), 0.0)
color(r, g, b) = vec3(Float64(r), Float64(g), Float64(b))
magnitude(a::svec) = sqrt(sum(x^2 for x in a))
normalise(a::svec) = a / magnitude(a)
intersections() = intersections(0, Vector{intersection}())
intersection(t::Float64, s::sphere) = intersection(t, s.id)
intersection(t::Int, s::sphere) = intersection(Float64(t), s.id)

function hit(is::intersections)
    if length(is.array[Bool[x.t >= 0.0 for x in is.array]]) == 0
        return()
    end
    return(sort(is.array[Bool[x.t >= 0.0 for x in is.array]], by = v -> v.t)[1])
end
