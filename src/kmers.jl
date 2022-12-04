

function create_kmer_vector(seq::LongDNA, k::Int64)
    k -= 1
    return [view(seq, i:i+k) for i in 1:length(seq)-k]
end


function single_match_kmer_dict(kmer_vector::Vector{LongSubSeq{DNAAlphabet{4}}})
    kmer_dict = Dict{LongSubSeq{DNAAlphabet{4}}, Int64}()
    for (i, kmer) in enumerate(kmer_vector)
        if !haskey(kmer_dict, kmer)
            kmer_dict[kmer] = i
        end
    end
    return kmer_dict
end

function single_match_kmer_dict(seq::LongDNA{4}, k::Int64)
    return single_match_kmer_dict(create_kmer_vector(seq, k))
end


function single_match_indices(
    seq::LongDNA{4},
    kmer_dict::Dict{LongSubSeq{DNAAlphabet{4}}, Int64},
    k_::Int64,
    step::Int64=1,
)
    return filter(!iszero, Int64[get(kmer_dict, view(seq, i:i+k_), 0) for i in 1:step:length(seq)-k_])
#    return index_vector[index_vector .!= 0]
end


function multi_match_kmer_dict(kmer_vector::Vector{LongSubSeq{DNAAlphabet{4}}})
    kmer_dict = Dict{LongSubSeq{DNAAlphabet{4}}, Vector{Int64}}()
    for (i, kmer) in enumerate(kmer_vector)
        if !haskey(kmer_dict, kmer)
            kmer_dict[kmer] = [i]
        else
            push!(kmer_dict[kmer], i)
        end
    end
    return kmer_dict
end

function multi_match_kmer_dict(seq::LongDNA{4}, k::Int64)
    return multi_match_kmer_dict(create_kmer_vector(seq, k))
end


empty_vector = Int64[]

function multi_match_indices(
    seq::LongDNA{4},
    kmer_dict::Dict{LongSubSeq{DNAAlphabet{4}}, Vector{Int64}},
    k_::Int64,
    step::Int64=1,
)
    return filter(!isempty, Vector{Int64}[get(kmer_dict, view(seq, i:i+k_), empty_vector) for i in 1:step:length(seq)-k_]) 
end

#index_vectors::Vector{Vector{Int64}} = [get(kmer_dict, view(seq, i:i+k), empty_vector) for i in 1:step:length(seq)-k]
#index_vectors[(!isempty).(index_vectors)]

#=kmer_dict = single_match_kmer_dict(create_kmer_vector(dna"ATACATACATACATACGATCGACCTACGACTC", 4))
indices = single_match_indices(dna"ATACAGATCGACCATCG", kmer_dict, 4)=#