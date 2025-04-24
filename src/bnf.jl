module bnf

include("Lexer/lexer.jl")
for x in ARGS
    if isfile(x)
        lines = readlines(x)
        for i in eachindex(lines)
            lexer = init_lexer(lines[i], x, i)
            while peek(lexer).token_kind != EOLToken
                println(lexer.token_buffer)
                next(lexer)
            end
        end

    end
end
end
