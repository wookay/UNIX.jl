module test_unix_ls

cwd = normpath(pwd(), ".")

using Test
using UNIX

change_to_dir = normpath(@__DIR__, "..") # UNIX/test
if cwd != change_to_dir
    @info :cd change_to_dir
    cd(change_to_dir)
end
fs = ls()
@info :ls fs
fnames = [f.name for f in fs]
@test "unix" in fnames
@test "runtests.jl" in fnames

unix = fs["unix"]
@test isdir(unix)
@test unix isa UNIX.FileInfo
@test ls(unix) == ls("unix")

not_file = fs["not_file"]
@test not_file === nothing

cd(cwd)

end # module test_unix_ls
