module test_filesystem

using Test
using Base.Filesystem: unlink

@test all(cmd -> cmd isa Function, [
    cd,
    chmod,
    chown,
    cp,
    mkdir,
    mktemp,
    mv,
    pwd,
    readlink,
    rm,
    touch,
    unlink,
    ])

end # module test_filesystem
