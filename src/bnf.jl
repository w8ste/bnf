module bnf

include("Lexer/lexer.jl")
include("Parser/parser.jl")

for x in ARGS
    if isfile(x)
        grammer = String[]
        rules = Rule[]
        lines = readlines(x)
        for i in eachindex(lines)
            lexer = init_lexer(lines[i], x, i)
            r = parse(lexer, grammer)
            if isnothing(r)
                continue
            end
            println(r)
            push!(rules, r)
        end
        undefs = find_undefined_symbols(rules)
        if !isempty(undefs)
            throw(UndefinedSymbolError("Undefined symbol found", undefs))
            end
    end
end
end
