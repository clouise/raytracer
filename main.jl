using StaticArrays
using BenchmarkTools
using Printf
using LinearAlgebra
import Base.push!

include("./raytracer/raytracer.jl")
include("./raytracer/canvas.jl")
include("./raytracer/transformations.jl")
include("./raytracer/rays.jl")

# Test writing a circle to a ppm file
width = 500
height = 500
c = canvas(width, height)

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
canvasPixels = 500
pixelSize = wallSize / canvasPixels
half = wallSize / 2

c = canvas(canvasPixels, canvasPixels)
col = color(1, 0, 0) # red
shape = sphere()
shape.transform = scaling(1, 0.5, 1)

@inbounds for y in 1:canvasPixels
    worldY = half - pixelSize * y
    @inbounds for x in 1:canvasPixels
        worldX = -half + pixelSize * x
        posit = point(worldX, worldY, wallZ)
        r = ray(rayOrigin, normalise(posit - rayOrigin))
        xs = intersect(shape, r)
        if hit(xs) != ()
            writePixel(c, x, y, col)
        end
    end
end

canvasToPPM(c, "circle.ppm")
