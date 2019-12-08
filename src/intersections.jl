struct Intersection
    t::Float64
    object::Sphere
end

mutable struct Intersections
    count::Int
    array::Vector{Intersection}
end

function push!(is::Intersections, i::Intersection)
    push!(is.array, i)
    is.count += 1
end

Intersections() = Intersections(0, Vector{Intersection}())
#Intersection(t::Float64, s::Sphere) = Intersection(t, s)
Intersection(t::Int, s::Sphere) = Intersection(Float64(t), s)

function hit(is::Intersections)
    if length(is.array[Bool[x.t >= 0.0 for x in is.array]]) == 0
        return()
    end
    return(sort(is.array[Bool[x.t >= 0.0 for x in is.array]], by = v -> v.t)[1])
end

function reflect(invec::svec, normal::svec)
    return invec - normal * 2 * dot(invec, normal)
end
