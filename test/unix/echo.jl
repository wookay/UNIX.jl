module test_unix_echo

using Test
using UNIX

@test echo("hello") == "hello\n"
@test echo("hello", n=true) == "hello"

end # module test_unix_ls
