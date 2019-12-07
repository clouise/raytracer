struct ray
    origin::svec
    direction::svec
end

function transform(r::ray, m::SArray)
    ro = m * r.origin
    rd = m * r.direction
    return(ray(ro, rd))
end

function position(r::ray, t)
    return(r.origin + r.direction * t)
end

function intersect(sphere::sphere, r::ray)
    tRay = transform(r, inv(sphere.transform))
    sphereToRay = tRay.origin - point(0, 0, 0)
    a = dot(tRay.direction, tRay.direction)
    b = 2 * dot(tRay.direction, sphereToRay)
    c = dot(sphereToRay, sphereToRay) - 1
    discriminant = b^2 - 4 * a * c
    if discriminant < 0.0
        return(intersections(0, []))
    end
    t1 = (-b - sqrt(discriminant)) / (2 * a)
    t2 = (-b + sqrt(discriminant)) / (2 * a)
    return(intersections(2, [intersection(t1, sphere.id), intersection(t2, sphere.id)]))
end
