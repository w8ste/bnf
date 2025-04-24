include("../Lexer/utils.jl")

struct ParseError <: Exception
    m::String
    loc::Location
end

function Base.show(io::IO, loc::Location)
    print(io, "$(loc.filePath):$(loc.row):$(loc.column)")
end
