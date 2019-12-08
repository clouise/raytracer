using RayTracer, Test

@testset "magnitude" begin
    @test magnitude(vector(0, 1, 0)) == 1.0
end


