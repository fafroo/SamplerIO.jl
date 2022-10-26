using SamplerIO, DataFrames
using Test

@testset "SamplerIO.jl" begin
    simpletests = Dict(
        Dict(:A              => (    "Lin",  -10., 10., 1.0e-1, 3)) => DataFrame(A = 0.1 .*LinRange(-10.0, 10.0, 3)),
        Dict(:B              => (    "Log",   -1.,  1.,    3.0, 3)) => DataFrame(B = 3.0*10 .^LinRange(-1.0, 1.0, 3)),
        Dict(:C              => (    "PLin",  -3.,  5., 1.0e1))     => DataFrame(C = [10.0, 30.0, -10.0]),
        Dict(:D              => (    "PLog",  -1.,   1., 5.0))      => DataFrame(D = [5.0, 15.811388300841898,1.5811388300841898 ]),
 
    )
    for (test, result) in simpletests
        @test isapprox(sample(test, N=3, sobolskip=false), result)
    end
    #
    ABCDresult = DataFrame(
        :A =>  [-ones(12)..., zeros(12)..., ones(12)...],
        :B => repeat([repeat([0.3],4)..., repeat([3.0],4)..., repeat([30.0],4)...],3),
        :D => repeat([5.0, 15.811388300841898, 1.5811388300841898, 2.8117066259517456], 9), # TODO rearrange the columns back after sampling according to the input dict
        :C => repeat([10.0, -10.0, 30.0,  0.0],9), 
    )
    mergedcase = merge([key for (key,val) in simpletests]...)
    @test isapprox(sample(mergedcase, N=3*3*2*2, sobolskip=false), ABCDresult)
end
