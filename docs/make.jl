push!(LOAD_PATH,"../src/")
using Documenter, SamplerIO

function mkdocs()
    makedocs(
        sitename = "SamplerIO.jl",
        modules = [SamplerIO],
        # clean=false,
        authors = "P. Vagner",
        repo = "https://github.com/fafroo/SamplerIO.jl",
        pages=["Home" => "index.md"]
    )
end

mkdocs()
deploydocs(
    repo = "github.com/fafroo/SamplerIO.jl"
)
