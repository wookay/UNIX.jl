module test_unix_tail

using Test
using UNIX

fs = ls(".")
runtestsjl = fs["runtests.jl"]
lines = tail(runtestsjl, 2)
@test lines == ["using Jive", "runtests(@__DIR__)"]

end # module test_unix_tail
