global inc = 0

svec = MVector{4, Float64}
trans = SMatrix{4, 4, Float64}
vec3 = SVector{3, Float64}


point(x, y, z) = svec(Float64(x), Float64(y), Float64(z), 1.0)
vector(x, y, z) = svec(Float64(x), Float64(y), Float64(z), 0.0)
color(r, g, b) = vec3(Float64(r), Float64(g), Float64(b))
magnitude(a::svec) = sqrt(sum(x^2 for x in a))
normalise(a::svec) = a / magnitude(a)
