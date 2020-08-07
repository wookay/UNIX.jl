# module UNIX

# https://github.com/wertarbyte/coreutils/blob/master/src/ls.c

@enum FileType begin
    unknown
    fifo
    chardev
    directory
    blockdev
    normal
    symbolic_link
    sock
    whiteout
    arg_directory
end

struct FileInfo
    root::Ref
    name
    filetype::FileType
end

function ls()
    dir = pwd()
    ls(dir)
end

function ls(dir)::Vector{FileInfo}
    walkdir_list = walkdir(dir)
    (root, dirs, files) = first(walkdir_list)
    refroot = Ref(abspath(root))
    sort(vcat(
        [FileInfo(refroot, name, directory) for name in dirs],
        [FileInfo(refroot, name, normal) for name in files],
    ), by=f -> f.name)
end

function ls(dir::FileInfo)::Vector{FileInfo}
    ls(normpath(dir.root[], dir.name))
end

function Base.getindex(fs::Vector{FileInfo}, name::String)::Union{Nothing, FileInfo}
    idx = findfirst(f -> f.name == name, fs)
    idx === nothing ? nothing : fs[idx]
end

function Base.isdir(f::FileInfo)
    f.filetype === directory
end

function Base.:(==)(l::Vector{FileInfo}, r::Vector{FileInfo})
    length(l) == length(r) || return false
    a = [(f.root[], f.name, f.filetype) for f in l]
    b = [(f.root[], f.name, f.filetype) for f in r]
    a == b
end

function Base.show(io::IO, mime::MIME"text/plain", f::FileInfo)
    if isdir(f)
        printstyled(io, f.name, color=:cyan, bold=true)
    else
        print(io, f.name)
    end
end

# module UNIX
