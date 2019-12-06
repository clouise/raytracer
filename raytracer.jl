using StaticArrays
using BenchmarkTools
using Printf
import Base.push!

global inc = 0

svec = SVector{4, Float64}
trans = SMatrix{4, 4, Float64}
vec3 = SVector{3, Float64}

function translation(x, y, z)
    i = SA_F64[1 0 0 x; 0 1 0 y; 0 0 1 z; 0 0 0 1]
    return(i)
end

function scaling(x, y, z)
    i = SA_F64[x 0 0 0; 0 y 0 0; 0 0 z 0; 0 0 0 1]
    return(i)
end

function rotationX(r)
    i = SA_F64[1 0 0 0; 0 cos(r) -sin(r) 0; 0 sin(r) cos(r) 0; 0 0 0 1]
    return(i)
end

function rotationY(r)
    i = SA_F64[cos(r) 0 sin(r) 0; 0 1 0 0; -sin(r) 0 cos(r) 0; 0 0 0 1]
    return(i)
end

function rotationZ(r)
    i = SA_F64[cos(r) -sin(r) 0 0; sin(r) cos(r) 0 0; 0 0 1 0; 0 0 0 1]
    return(i)
end

function shearing(xy, xz, yx, yz, zx, zy)
    i = SA_F64[1 xy xz 0; yx 1  yz 0; zx zy 1 0; 0 0 0 1]
    return(i)
end

struct ray
    origin::svec
    direction::svec
end

function position(r::ray, t)
    return(r.origin + r.direction * t)
end

struct sphere
    id::Int
end

function sphere()
    global inc += 1
    return(sphere(inc))
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

function intersect(sphere::sphere, r::ray)
    sphereToRay = r.origin - point(0, 0, 0)
    a = dot(r.direction, r.direction)
    b = 2 * dot(r.direction, sphereToRay)
    c = dot(sphereToRay, sphereToRay) - 1
    discriminant = b^2 - 4 * a * c
    if discriminant < 0.0
        return()
    end
    t1 = (-b - sqrt(discriminant)) / (2 * a)
    t2 = (-b + sqrt(discriminant)) / (2 * a)
    return(intersections(2, [intersection(t1, sphere.id), intersection(t2, sphere.id)]))
    #return(sphere.id, (t1, t2))
end

struct projectile
    position::svec
    velocity::svec
end

struct environment
    gravity::svec
    wind::svec
end

function tick(proj::projectile, env::environment)
    position = proj.position + proj.velocity
    velocity = proj.velocity + env.gravity + env.wind
    return(projectile(position, velocity))
end

mutable struct canvas
    width::UInt
    height::UInt
    pixels::Array{Any}
end

function writePixel(canvas, x, y, color)
    canvas.pixels[x, y, :] = color
end

function canvasToPPM(canvas, filename::AbstractString)
    clamp!(c.pixels, 0, 1)
    c.pixels = map(x -> Int(round((x - 0) / (1 - 0) * (255 - 0) + 0)), c.pixels)
    io = open(filename, "w")
    header = @sprintf("P3\n%s %s\n255\n", canvas.width, canvas.height)
    write(io, header)
    for j in 1:canvas.height
        for i in 1:canvas.width
            for k in 1:3
                write(io, string(canvas.pixels[i, j, k]), " ")
            end
        end
        write(io, "\n")
    end
    close(io)
end

function iterate(canvas)
    for j in 1:canvas.height
        for i in 1:canvas.width
            for k in 1:3
                print(canvas.pixels[i, j, k], " ")
            end
        end
        print("\n")
    end
end

point(x, y, z) = svec(Float64(x), Float64(y), Float64(z), 1.0)
vector(x, y, z) = svec(Float64(x), Float64(y), Float64(z), 0.0)
color(r, g, b) = vec3(Float64(r), Float64(g), Float64(b))
magnitude(a::svec) = sqrt(sum(x^2 for x in a))
normalise(a::svec) = a / magnitude(a)
intersections() = intersections(0, Vector{intersection}())
intersection(t::Float64, s::sphere) = intersection(t, s.id)

canvas(width, height) = canvas(width, height, zeros(Int, width, height, 3))

width = 500
height = 500
c = canvas(width, height)

#canvasToPPM(c, "test.ppm")
for i in 1:12
    p = point(0, 0, 1)
    p = rotationY(i * pi / 6) * p
    p = p * 3/8 * width
    writePixel(c, Int(round(p[3])) + div(width, 2),
               Int(round(p[1])) + div(width, 2), color(1, 1, 1))
end


c.pixels

canvasToPPM(c, "test.ppm")