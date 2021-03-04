using Memoization
using BenchmarkTools


const i_n = 512
const side = 2048
const center = 0.4+0.4im
const scale = 0.3

function solvePixel(i; i_n=512, side=1024, center=0.4 + 0.4im, scale=0.3)
    y, x = divrem(i, side)
    c = (x / side * 2 * scale - scale) + (y / side * 2 * scale - scale) * 1im + center
    z = 0im
    k = 0
    while (k < i_n)
        z = z * z + c
        abs(z) <= 2 ? k += 1 : break 
    end
    return floor((1 - k / i_n) * 255)
end

function main(side = 2048)
    open("out.ppm", "w") do io
        write(io, "P6 $side $side 255 ")
        buffer = zeros(UInt8, side, side * 3)
        Base.Threads.@threads for i in 0:side - 1
            tmp = i * side
            for j in 1:side
                idx = tmp + j
                res = solvePixel(idx; side = side)
                @inbounds buffer[i+1,j * 3 - 2] = res
                @inbounds buffer[i+1,j * 3 - 1] = res
                @inbounds buffer[i+1,j * 3 - 0] = res
            end
        end                     
        write(io, buffer)   
    end
end

main()