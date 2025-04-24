include("lexer_errors.jl")
include("utils.jl")

@enum TokenKind begin
	EmptyToken
    NonTerminalToken
    MetaToken
    ExpressionToken
    EOLToken
    PundentToken
end

struct Token
    token_kind::TokenKind
    content::String
    location::Location
end

struct TokenLiteral
    name::String
    token_kind::TokenKind
end

const TokenKindName = Dict(
    EmptyToken => "",
    NonTerminalToken => "symbol",
    MetaToken => "is replaced by",
    ExpressionToken => "_expr_",
    EOLToken => "\n",
    PundentToken => "|"
)

const TokenLiterals = [
    TokenLiteral("::=", MetaToken)
]

mutable struct Lexer
    content::String
    filePath::String
    row::Int
    column::Int
    token_buffer_full::Bool
    token_buffer::Token
end


function make_location(filepath::String, row::Int, column::Int)
    Location(filepath, row, column)
end

# Initialize a lexer
function init_lexer(input::String, filePath::String, row::Int)
    Lexer(input, filePath, row, 1, false, Token(EmptyToken, "", make_location(filePath, row, 1)))
end

function trim(lexer::Lexer)
    while lexer.column < length(lexer.content) && lexer.content[lexer.column] == ' '
        lexer.column += 1
    end
end

function next(lexer::Lexer)
	if lexer.token_buffer_full
        lexer.token_buffer_full = false
        return lexer.token_buffer
    end
    return extract_token(lexer)
end

function peek(lexer::Lexer)

    if lexer.token_buffer_full
        return lexer.token_buffer
    else
        lexer.token_buffer_full = true
    end
    return extract_token(lexer)
end

function extract_token(lexer::Lexer)
    trim(lexer)
    loc::Location = Location(lexer.filePath, lexer.row, lexer.column)

    if lexer.column > length(lexer.content) || lexer.content[lexer.column] == ' '
        lexer.token_buffer = Token(EOLToken, "\n", loc)
    elseif lexer.content[lexer.column] == '<'
        start::Int = lexer.column
        lexer.column += 1
        while lexer.column <= length(lexer.content) && lexer.content[lexer.column] != '>'
            lexer.column += 1
        end
        loc.column = lexer.column

        if lexer.column > length(lexer.content)
            throw(LexerErr("Undetermined Non-Terminal. Expected '>'", loc))
        elseif lexer.content[lexer.column] == '>'
           lexer.column += 1
        end
        lexer.token_buffer = Token(NonTerminalToken, lexer.content[start:loc.column], loc)
    elseif lexer.column <= length(lexer.content) + 2 && lexer.content[lexer.column] == ':'
        if lexer.content[lexer.column + 1] != ':' || lexer.content[lexer.column + 2] != '='
            throw(LexerErr("Invalid metasymbol, Expected '::='", loc))
        end
        lexer.column += 2
        loc.column = lexer.column
        lexer.token_buffer = Token(MetaToken, lexer.content[lexer.column-2:lexer.column], loc)
        lexer.column += 1
    elseif lexer.column <= length(lexer.content) && lexer.content[lexer.column] == '|'
        lexer.token_buffer = Token(PundentToken, lexer.content[lexer.column], loc)
        lexer.column += 1
    else
        throw(LexerErr("No Token Exception", loc))
    end

    return lexer.token_buffer
end
