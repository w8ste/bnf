module bnf
include("Lexer/lexer.jl")
for x in ARGS
    println(ispath(x))
end
end
