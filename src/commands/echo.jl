# module UNIX

function echo(str; n::Bool=false)
    n && return str
    return string(str, '\n')
end

# module UNIX
