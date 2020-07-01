using Test
using Bijections

b = Bijection(3,"Hello")
@test b[3] == "Hello"
@test b("Hello") == 3

b[2] = "Bye"
@test b[2] == "Bye"
@test b("Bye") == 2
@test inverse(b,"Bye") == 2


@test domain(b) == Set([2,3])
@test image(b) == Set(["Bye", "Hello"])

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
