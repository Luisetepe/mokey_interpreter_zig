const ILLEGAL = "ILLEGAL";
const EOF = "EOF";

// Identifiers + literals
const IDENT = "IDENT"; // add, foobar, x, y, ...
const INT = "INT"; // 1343456

// Operators
const ASSIGN = "=";
const PLUS = "+";

// Delimiters;
const COMMA = ",";
const SEMICOLON = ";";
const LPAREN = "(";
const RPAREN = ")";
const LBRACE = "{";
const RBRACE = "}";

// Keywords;
const FUNCTION = "FUNCTION";
const LET = "LET";

const TokenType = []u8;
const Token = struct { Type: TokenType, Literal: []u8 };
