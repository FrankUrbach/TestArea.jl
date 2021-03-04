
const i_n = 512
const side = 1024
const center = 0.4+0.4im
const scale = 0.3

const xs = range(-scale, scale, length=side)
const ys = range(-scale, scale, length=side) .* 1im

const r = [0 for _ in 1:side*side]

let
    c = [x + y for y in ys for x in xs] .+ center
    z = zeros(side*side)
    for i in 1:i_n
        z = z .* z .+ c
        r[abs.(z) .< 2] .= i
    end
end
bytes = Vector{UInt8}("P6 $side $side 255 ")
const arr = Vector{UInt8}( floor.(255 .- (r ./ i_n .* 255)))
const content = reshape(transpose(repeat(arr, outer=[1, 3])), (side*side*3,))
append!(bytes, content)
open("out.ppm", "w") do io
    write(io, bytes)
end