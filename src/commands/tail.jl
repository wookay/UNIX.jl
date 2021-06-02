# module UNIX

function tail(f::FileInfo, n)
    path = normpath(f.root[], f.name)
    lines = readlines(path)
    lines[end-n+1: end]
end

# module UNIX
