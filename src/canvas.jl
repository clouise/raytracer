mutable struct Canvas
    width::UInt
    height::UInt
    pixels::Array{Any}
end

function writePixel(canvas, x, y, color)
    canvas.pixels[x, y, :] = color
end

Canvas(width, height) = Canvas(width, height, zeros(Int, width, height, 3))

function canvasToPPM(canvas::Canvas, filename::AbstractString)
    # takes a canvas object. clamps the values between 0 and 1
    # then maps those values between 0 and 255
    # finally write the canvas object into a PPM object
    clamp!(canvas.pixels, 0, 1)
    canvas.pixels = map(x -> Int(round((x - 0) / (1 - 0) * (255 - 0) + 0)), canvas.pixels)
    io = open(filename, "w")
    header = "P3\n" * string(canvas.width) * " " * string(canvas.height) * "\n255\n"
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
