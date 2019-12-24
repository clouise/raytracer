using Pkg
using BenchmarkTools

Pkg.activate("RayTracer")

using Printf
using RayTracer

# Ray trace a sphere
rayOrigin = point(0, 0, -5)
wallZ = 20
wallSize = 14.0
canvasPixels = 1000
pixelSize = wallSize / canvasPixels
half = wallSize / 2

c = Canvas(canvasPixels, canvasPixels)

# First 3d Render
sphere = Sphere()
sphere.material = Material()
sphere.material.color = color(1, 0.2, 1)

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


@benchmark render()

canvasToPPM(c, "./raytracer/123.ppm")
