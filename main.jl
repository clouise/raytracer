include("./raytracer/raytracer.jl")

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


# Generate a collection of intersections
s = sphere()
i1 = intersection(5, s)
i2 = intersection(7, s)
i3 = intersection(-3, s)
i4 = intersection(2, s)

xs = intersections(4, [i1, i2, i3, i4])

hit(xs)


