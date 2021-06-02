module test_unix_tail

using Test
using UNIX

fs = ls(".")
runtestsjl = fs["runtests.jl"]
@test tail(runtestsjl, 3) == ["using Jive", "runtests(@__DIR__)"]
@test tail(runtestsjl, 2) == ["using Jive", "runtests(@__DIR__)"]
@test tail(runtestsjl, 1) == ["runtests(@__DIR__)"]
@test tail(runtestsjl, 0) == []

end # module test_unix_tail
