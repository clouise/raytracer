using StaticArrays
using BenchmarkTools
using Printf
using LinearAlgebra
import Base.push!

include("./raytracer/raytracer.jl")
include("./raytracer/material.jl")
include("./raytracer/sphere.jl")
include("./raytracer/canvas.jl")
include("./raytracer/transformations.jl")
include("./raytracer/rays.jl")
include("./raytracer/light.jl")
include("./raytracer/intersections.jl")

# Test writing a circle to a ppm file
width = 500
height = 500
c = Canvas(width, height)

for i in 1:12
    p = point(0, 0, 1)
    p = rotationY(i * pi / 6) * p
    p = p * 3/8 * width
    writePixel(c, Int(round(p[3])) + div(width, 2),
               Int(round(p[1])) + div(width, 2), color(1, 1, 1))
end

c.pixels

canvasToPPM(c, "test.ppm")

# Ray trace a sphere
rayOrigin = point(0, 0, -5)
wallZ = 10
wallSize = 7.0
canvasPixels = 1000
pixelSize = wallSize / canvasPixels
half = wallSize / 2

c = Canvas(canvasPixels, canvasPixels)

# First 3d Render
sphere = Sphere()
sphere.material = Material()
sphere.material.color = color(1, 0.2, 1)
sphere.transform = scaling(1, .65, 1)

light_position = point(-10, 10, -10)
light_color = color(1, 1, 1)
light = PointLight(light_position, light_color)

@inbounds for y in 1:canvasPixels
    worldY = half - pixelSize * y
    @inbounds for x in 1:canvasPixels
        worldX = -half + pixelSize * x
        posit = point(worldX, worldY, wallZ)
        ray = Ray(rayOrigin, normalise(posit - rayOrigin))
        ray.direction = normalise(ray.direction)
        eye = -1 * ray.direction
        xs = intersect(sphere, ray)
        if hit(xs) != ()
            point2 = position(ray, hit(xs).t)
            normal = normal_at(hit(xs).object, point2)
            col = lighting(hit(xs).object.material, light, point2, eye, normal)
            writePixel(c, x, y, col)
        end
    end
end

canvasToPPM(c, "sphere.ppm")

