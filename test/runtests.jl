using Test
using Bijections
using Serialization

@testset "Basics" begin
    b = Bijection(3, "Hello")
    @test b[3] == "Hello"
    @test b("Hello") == 3
    @test haskey(b, 3)
    @test !haskey(b, 4)
    @test !haskey(b, "Hello")

    b[2] = "Bye"
    @test b[2] == "Bye"
    @test b("Bye") == 2
    @test inverse(b, "Bye") == 2

    @test length(b) == 2
    @test !isempty(b)

    bb = inv(b)
    @test bb["Bye"] == 2
    bb["xx"] = 4
    @test length(bb) != length(b)

    bb = active_inv(b)
    @test bb["Bye"] == 2
    b[0] = "Ciao"
    @test bb["Ciao"] == 0
    @test inv(bb) == b

    # conversion to a Dict
    d = Dict(b)
    @test d[0] == b[0]
    @test Bijection(d) == b

    # check pair constructor
    @test Bijection(collect(b)) == b
end

# Test empty constructor
@testset "empty_constructor" begin
    b = Bijection{Int,String}()
    @test length(b) == 0

    b = Bijection{Int,String,Dict{Int,String},Dict{String,Int}}()
    @test length(b) == 0

    b = Bijection{Int,String,IdDict{Int,String},IdDict{String,Int}}()
    @test length(b) == 0
end

# Test constructor with arguments
@testset "constructor_with_args" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    @test length(b) == 2
    @test b[1] == "one"
    @test b[2] == "two"

    b = Bijection{Int,String,Dict{Int,String},Dict{String,Int}}(1 => "one", 2 => "two")
    @test length(b) == 2
    @test b[1] == "one"
    @test b[2] == "two"

    b = Bijection{Int,String,IdDict{Int,String},IdDict{String,Int}}(1 => "one", 2 => "two")
    @test length(b) == 2
    @test b[1] == "one"
    @test b[2] == "two"
end

# Test constructor from dictionary
@testset "constructor_from_dict" begin
    d = Dict(1 => "one", 2 => "two")
    b = Bijection(d)
    @test length(b) == 2
    @test b[1] == "one"
    @test b[2] == "two"

    d = IdDict(1 => "one", 2 => "two")
    b = Bijection(d)
    @test length(b) == 2
    @test b[1] == "one"
    @test b[2] == "two"

    # test construction with different Finv dictionary type
    d = Dict("one" => 1, "two" => 2)
    b = Bijection{String,Int,Dict{String,Int},IdDict{Int,String}}(d)
    @test length(b) == 2
    @test b["one"] == 1
    @test b["two"] == 2

    # test construction from ImmutableDict
    d = Base.ImmutableDict(1 => "one", 2 => "two")
    b = Bijection(d)
    @test length(b) == 2
    @test b[1] == "one"
    @test b[2] == "two"
end

# Test inv function
@testset "inv" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    inv_b = inv(b)
    @test length(inv_b) == 2
    @test inv_b["one"] == 1
    @test inv_b["two"] == 2
    @test inv_b.f !== b.finv && inv_b.f == b.finv
    @test inv_b.finv !== b.f && inv_b.finv == b.f
end

# Test active_inv function
@testset "active_inv" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    active_b = active_inv(b)
    @test length(active_b) == 2
    @test active_b["one"] == 1
    @test active_b["two"] == 2
    @test active_b.f === b.finv
    @test active_b.finv === b.f
end

# Test copy function
@testset "copy" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    b_copy = copy(b)
    @test length(b_copy) == 2
    @test b_copy[1] == "one"
    @test b_copy[2] == "two"
end

# Test empty function
@testset "empty" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    empty_b = empty(b)
    @test length(empty_b) == 0
    @test typeof(empty_b) == typeof(b)
end

# Test getindex function
@testset "getindex" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    @test b[1] == "one"
    @test b[2] == "two"
end

# Test setindex! function
@testset "setindex!" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    b[3] = "three"

    @test length(b) == 3
    @test b[3] == "three"
    @test b("three") == 3

    # test update of existing key
    b[1] = "uno"
    @test b[1] == "uno"
    @test !hasvalue(b, "one")
end

# Test get function
@testset "get" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    @test get(b, 1, "default") == "one"
    @test get(b, 2, "default") == "two"
    @test get(b, 3, "default") == "default"
end

# Test sizehint! function
@testset "sizehint!" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    nslots = length(b.f.slots)
    sizehint!(b, nslots + 1)
    @test length(b) == 2
    @test length(b.f.slots) > nslots
end

# Test iterate function
@testset "iterate" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    @test issetequal(collect(b), [1 => "one", 2 => "two"])
end

# Test keys function
@testset "keys" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    @test issetequal(keys(b), [1, 2])
    @test issetequal(keys(inv(b)), ["one", "two"])
end

# Test values function
@testset "values" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    @test issetequal(values(b), ["one", "two"])
    @test issetequal(values(inv(b)), [1, 2])
end

# Test haskey function
@testset "haskey" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    @test haskey(b, 1)
    @test haskey(b, 2)
    @test !haskey(b, 3)

    # test haskey with mutable key type on `Dict`
    b = Bijection{Vector{Int},String}([1] => "one", [2] => "two")
    @test haskey(b, [1])
    @test haskey(b, [2])
    @test !haskey(b, [3])

    # test haskey with mutable key type on `IdDict`
    k1 = [1]
    k2 = [2]
    b = Bijection{Vector{Int},String,IdDict{Vector{Int},String},IdDict{String,Vector{Int}}}(
        k1 => "one", k2 => "two"
    )
    @test haskey(b, k1)
    @test haskey(b, k2)
    @test !haskey(b, [1])
    @test !haskey(b, [2])
    @test !haskey(b, [3])
end

# Test hasvalue function
@testset "hasvalue" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    @test hasvalue(b, "one")
    @test hasvalue(b, "two")
    @test !hasvalue(b, "three")

    # test hasvalue with mutable key type on `Dict`
    b = Bijection{String,Vector{Int}}("one" => [1], "two" => [2])
    @test hasvalue(b, [1])
    @test hasvalue(b, [2])
    @test !hasvalue(b, [3])

    # test hasvalue with mutable key type on `IdDict`
    v1 = [1]
    v2 = [2]
    b = Bijection{String,Vector{Int},IdDict{String,Vector{Int}},IdDict{Vector{Int},String}}(
        "one" => v1, "two" => v2
    )
    @test hasvalue(b, v1)
    @test hasvalue(b, v2)
    @test !hasvalue(b, [1])
    @test !hasvalue(b, [2])
    @test !hasvalue(b, [3])
end

# Test delete! function
@testset "delete!" begin
    b = Bijection{Int,String}(1 => "one", 2 => "two")
    delete!(b, 1)
    @test !haskey(b, 1)
    @test !haskey(inv(b), "one")
end

@testset "Serialization" begin
    using Serialization

    @testset "bijection with immutable keys / values" begin
        b = Bijection{Int,Symbol}(1 => :one, 2 => :two)
        write_io = IOBuffer()
        serialize(write_io, b)
        data = take!(write_io)

        read_io = IOBuffer(data)
        b_reconstructed = deserialize(read_io)

        @test typeof(b_reconstructed) == typeof(b)
        @test b_reconstructed.f == b.f
        @test b_reconstructed.finv == b.finv
    end

    @testset "bijection with mutable values" begin
        b = Bijection{Int,Vector{Int}}(1 => [1], 2 => [2])
        write_io = IOBuffer()
        serialize(write_io, b)
        data = take!(write_io)

        read_io = IOBuffer(data)
        b_reconstructed = deserialize(read_io)

        @test typeof(b_reconstructed) == typeof(b)
        @test b_reconstructed.f == b.f
        @test b_reconstructed.finv == b.finv
    end

    @testset "bijection with mutable values + IdDict" begin
        b = Bijection{Int,Vector{Int},Dict{Int,Vector{Int}},IdDict{Vector{Int},Int}}(
            1 => [1],
            2 => [1], # value repeated on purpose
        )
        write_io = IOBuffer()
        serialize(write_io, b)
        data = take!(write_io)

        read_io = IOBuffer(data)
        b_reconstructed = deserialize(read_io)

        @test typeof(b_reconstructed) == typeof(b)
        @test b_reconstructed.f == b.f

        # it uses a `IdDict` and the objectids are not the same, so order is not guaranteed
        @test issetequal(b_reconstructed.finv, b.finv)
    end
end
