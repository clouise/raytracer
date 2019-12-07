mutable struct canvas
    width::UInt
    height::UInt
    pixels::Array{Any}
end

function writePixel(canvas, x, y, color)
    canvas.pixels[x, y, :] = color
end

canvas(width, height) = canvas(width, height, zeros(Int, width, height, 3))

function canvasToPPM(canvas, filename::AbstractString)
    clamp!(c.pixels, 0, 1)
    c.pixels = map(x -> Int(round((x - 0) / (1 - 0) * (255 - 0) + 0)), c.pixels)
    io = open(filename, "w")
    header = @sprintf("P3\n%s %s\n255\n", canvas.width, canvas.height)
    write(io, header)
    @inbounds for j in 1:canvas.height
        @inbounds for i in 1:canvas.width
            for k in 1:3
                write(io, string(canvas.pixels[i, j, k]), " ")
            end
        end
        write(io, "\n")
    end
    close(io)
end
