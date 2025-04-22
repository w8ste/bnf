mutable struct Location
    filePath::String
    line::Int
    column::Int
end

@enum TokenKind begin
	EmptyToken 
end

struct Token
    token_kind::TokenKind
    content::Vector{Char}
    location::Location
end

mutable struct Lexer
    content::Vector{Char}
    filePath::String
    row::Int
    column::Int
    token_buffer_full::Bool
    token_buffer::Token
end

function make_location(filepath::String, row::Int, column::Int)
    Location(filepath, row, column)
end

function init_lexer(input::Vector{Char}, filePath::String, row::Int)
    Lexer(input, filePath, row, 0, false, Token(EmptyToken, [], make_location(filePath, row, 0)))
end
