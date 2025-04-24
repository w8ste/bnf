include("parser_error.jl")

struct Rule
    lhs::String
    rhs::Vector{Vector{String}}
end

function parse()
    
end

function parse_rhs()

end

function expect(lexer::Lexer, expected::TokenKind)
    v = next(lexer)
    println(v)
    if v.token_kind != expected
        throw(ParseError("Expected $(expected), but got $(v)", v.location))
    end
    return true
end
