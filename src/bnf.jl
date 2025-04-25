module bnf

include("Lexer/lexer.jl")
include("Parser/parser.jl")

for x in ARGS
    if isfile(x)
        lines = readlines(x)
        for i in eachindex(lines)
            grammer = String[]
            lexer = init_lexer(lines[i], x, i)
            r = parse(lexer, grammer)
            if isnothing(r)
                continue
            end
            println(r)
        end
    end
end
end
