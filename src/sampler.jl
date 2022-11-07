"""

    sample(dict)

Return DataFrames with samples described by dict.
"""
function sample(dict::Dict; N = 0, sobolskip=true)
    # TODO input of an array -> fixed pre-selected values
    # TODO check for an invalid input such as ("Lin", 0.0, 0.0, 10)
    # TODO ensure a minimum size of a sample
    detdf = DataFrame()
    # equidistant sampling
    deterministic = filter(p -> p.second[1] in["Lin", "Log"], dict)
    for (key,s) in deterministic 
        sample_range = LinRange(s[2],s[3],s[5])
        if s[1] == "Log"
           sample_range = s[4]*10 .^sample_range
        else
           sample_range = s[4]*sample_range
        end
        df = DataFrame(key=>sample_range)    
        if size(detdf) == (0,0)
            detdf = deepcopy(df)
        else
            detdf = crossjoin(detdf, df)
        end
    end
    # pseudorandom sampling 
    pseudorandom  = filter(p -> p.second[1] in["PLin", "PLog"], dict)

    lbs = [val[2] for (k,val) in pseudorandom]
    ubs = [val[3] for (k,val) in pseudorandom]
    sobolseq=Sobol.SobolSeq(lbs,ubs)

    rest = floor(Int32, N/(size(detdf)[1] == 0 ? 1.0 : size(detdf)[1] ))
    sobolskip && Sobol.skip(sobolseq, rest)

    psdf = DataFrame([Symbol.(key) => [] for key in keys(pseudorandom)])
    for i = 1:rest
        p = Sobol.next!(sobolseq)
        linorlog2!(p, pseudorandom)
        push!(psdf,Dict(Symbol.(keys(pseudorandom)) .=> p))
    end
    isempty(detdf) && return psdf
    isempty(psdf) && return detdf
    return crossjoin(detdf,psdf)
end

function linorlog2!(p, dict)
    for ((k,v), (i, val)) in zip(dict,enumerate(p))
        (v[1]=="PLog") ? (p[i] = v[4]*10^val) : (p[i] = v[4]*val)
    end
end