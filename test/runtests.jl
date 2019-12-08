using RayTracer, Test

@testset "magnitude" begin
    @test magnitude(vector(0, 1, 0)) == 1.0
    @test magnitude(vector(0, 0, 1)) == 1.0
    @test magnitude(vector(1, 2, 3)) == sqrt(14)
    @test magnitude(vector(-1, -2, -3)) == sqrt(14)
end

@testset "normalise" begin
    @test normalise(vector(4, 0, 0)) == vector(1, 0, 0)
    @test magnitude(normalise(vector(1, 2, 3))) == 1.0
end
