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
    stat::Base.Filesystem.StatStruct
end

function ls()
    dir = pwd()
    ls(dir)
end

function ls(path)::Vector{FileInfo}
    if isdir(path)
        walkdir_list = walkdir(path)
        (root, dirs, files) = first(walkdir_list)
        refroot = Ref(abspath(root))
        sort(vcat(
            [FileInfo(refroot, name, directory, lstat(normpath(root, name))) for name in dirs],
            [FileInfo(refroot, name, normal, lstat(normpath(root, name))) for name in files],
        ), by=f -> f.name)
    else
        (root, name) = splitdir(path)
        refroot = Ref(abspath(root))
        [FileInfo(refroot, name, normal, lstat(path))]
    end
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

function Base.islink(f::FileInfo)
    islink(f.stat)
end

function Base.:(==)(l::Vector{FileInfo}, r::Vector{FileInfo})
    length(l) == length(r) || return false
    all(
        (a.root[] == b.root[] && a.name == b.name && a.filetype === b.filetype && a.stat == b.stat)
        for (a, b) in zip(l, r))
end

function Base.show(io::IO, mime::MIME"text/plain", f::FileInfo)
    if islink(f.stat)
        printstyled(io, f.name, color=:magenta)
    else
        if isdir(f)
            printstyled(io, f.name, color=:cyan, bold=true)
        else
            print(io, f.name)
        end
    end
end

# module UNIX
