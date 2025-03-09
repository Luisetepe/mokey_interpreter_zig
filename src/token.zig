const std = @import("std");
const stringEqual = std.mem.eql;

pub const TokenType = enum {
    ILLEGAL,
    EOF,

    // Identifiers + literals
    IDENT, // add, foobar, x, y, ...
    INT, // 1343456

    // Operators
    ASSIGN,
    PLUS,
    MINUS, // Added support for minus
    SLASH, // Added support for division
    ASTERISK, // Added support for multiplication
    LT, // Added support for less than
    GT, // Added support for greater than
    BANG, // Added support for bang

    // Delimiters
    COMMA,
    SEMICOLON,
    LPAREN,
    RPAREN,
    LBRACE,
    RBRACE,

    // Keywords
    FUNCTION,
    LET,
    TRUE,
    FALSE,
    IF,
    ELSE,
    RETURN,

    pub fn toString(self: TokenType) []const u8 {
        return switch (self) {
            .ILLEGAL => "ILLEGAL",
            .EOF => "EOF",
            .IDENT => "IDENT",
            .INT => "INT",
            .ASSIGN => "=",
            .PLUS => "+",
            .MINUS => "-", // Added string representation for minus
            .SLASH => "/", // Added string representation for division
            .ASTERISK => "*", // Added string representation for multiplication
            .LT => "<", // Added string representation for less than
            .GT => ">", // Added string representation for greater than
            .BANG => "!", // Added string representation for bang
            .COMMA => ",",
            .SEMICOLON => ";",
            .LPAREN => "(",
            .RPAREN => ")",
            .LBRACE => "{",
            .RBRACE => "}",
            .FUNCTION => "FUNCTION",
            .LET => "LET",
            .TRUE => "TRUE",
            .FALSE => "FALSE",
            .IF => "IF",
            .ELSE => "ELSE",
            .RETURN => "RETURN",
        };
    }

    pub fn fromIdent(identStr: []const u8) TokenType {
        var result: TokenType = undefined;

        if (stringEqual(u8, identStr, "fn")) {
            result = TokenType.FUNCTION;
        } else if (stringEqual(u8, identStr, "let")) {
            result = TokenType.LET;
        } else if (stringEqual(u8, identStr, "true")) {
            result = TokenType.TRUE;
        } else if (stringEqual(u8, identStr, "false")) {
            result = TokenType.FALSE;
        } else if (stringEqual(u8, identStr, "if")) {
            result = TokenType.IF;
        } else if (stringEqual(u8, identStr, "else")) {
            result = TokenType.ELSE;
        } else if (stringEqual(u8, identStr, "return")) {
            result = TokenType.RETURN;
        } else {
            result = TokenType.IDENT;
        }

        return result;
    }
};

pub const Token = struct {
    type: TokenType,
    literal: []const u8,

    pub fn init(tokenType: TokenType, literal: []const u8) Token {
        return .{
            .type = tokenType,
            .literal = literal,
        };
    }
};
