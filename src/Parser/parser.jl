include("parser_error.jl")

struct Rule
    lhs::String
    rhs::Vector{Vector{String}}
end

function parse(lexer::Lexer, grammer::Vector{String})
    if peek(lexer).token_kind == EOLToken
        return
    end
    lhs = expect(lexer, NonTerminalToken)
    if lhs.content in grammer
        throw(ParseError("Symbol $(lhs.content) already defined", lhs.location))
    else
        push!(grammer, lhs.content)
    end
    expect(lexer, MetaToken)
    
    rhs = parse_rhs(lexer)
    return Rule(lhs.content, rhs)
end

function parse_rhs(lexer::Lexer)
    rhs = []
    options = String[]
    
    while peek(lexer).token_kind != EOLToken
        tok = next(lexer)
        
        if tok.token_kind == PundentToken
            push!(rhs, options)
            options = []
        else
            push!(options, tok.content)
        end
    end
    
    push!(rhs, options)
    return rhs
 end

function expect(lexer::Lexer, expected::TokenKind)
    v = next(lexer)

    if v.token_kind != expected
        throw(ParseError("Expected $(expected), but got $(v)", v.location))
    end
    return v
end
function find_undefined_symbols(rules::Vector{Rule})
    defined = Set(rule.lhs for rule in rules)
    referenced = Set{String}()

    for rule in rules
        for rhs in rule.rhs
            for symbol in rhs
                if startswith(symbol, "<") && endswith(symbol, ">")
                    push!(referenced, symbol)
                end
            end
        end
    end

    return setdiff(referenced, defined)
end
