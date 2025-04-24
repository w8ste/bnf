module bnf

include("Lexer/lexer.jl")
include("Parser/parser.jl")

for x in ARGS
    if isfile(x)
        lines = readlines(x)
        for i in eachindex(lines)
        
        end
      
    end
end
end
