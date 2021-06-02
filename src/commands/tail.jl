# module UNIX

function tail(f::FileInfo, n)
    path = normpath(f.root[], f.name)
    lines = readlines(path)
    if n > length(lines)
        lines
    else
        lines[end-n+1: end]
    end
end

# module UNIX
