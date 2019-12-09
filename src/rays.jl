mutable struct Ray
    origin::svec
    direction::svec
end

function transform(r::Ray, m::SArray)
    ro = m * r.origin
    rd = m * r.direction
    return(Ray(ro, rd))
end

function position(r::Ray, t)
    return(r.origin + r.direction * t)
end

function intersect(sphere::Sphere, r::Ray)
    tRay = transform(r, sphere.invtransform)
    sphereToRay = tRay.origin - point(0, 0, 0)
    a = dot(tRay.direction, tRay.direction)
    b = 2 * dot(tRay.direction, sphereToRay)
    c = dot(sphereToRay, sphereToRay) - 1
    discriminant = b^2 - 4 * a * c
    if discriminant < 0.0
        return(Intersections(0, []))
    end
    t1 = (-b - sqrt(discriminant)) / (2 * a)
    t2 = (-b + sqrt(discriminant)) / (2 * a)
    return(Intersections(2, [Intersection(t1, sphere), Intersection(t2, sphere)]))
end
