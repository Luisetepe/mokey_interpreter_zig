const std = @import("std");
const token = @import("token.zig");
const Token = token.Token;
const TokenType = token.TokenType;

pub const Lexer = struct {
    input: []const u8,
    position: usize, // current position in input (points to current char)
    readPosition: usize, // current reading position in input (after current char)

    pub fn init(input: []const u8) Lexer {
        return .{
            .input = input,
            .position = 0,
            .readPosition = 0,
        };
    }

    fn moveNext(self: *Lexer) void {
        self.position = self.readPosition;
        self.readPosition += 1;
    }

    pub fn readIdentifier(self: *Lexer) []const u8 {
        const initPos = self.position;
        var char = self.input[self.readPosition];

        while (isLetter(char)) : (char = self.input[self.readPosition]) {
            self.moveNext();
        }

        return self.input[initPos..self.readPosition];
    }

    pub fn nextToken(self: *Lexer) Token {
        var tok: Token = undefined;
        var char: u8 = undefined;
        var slice: []const u8 = undefined;

        if (self.readPosition >= self.input.len) {
            char = 0;
        } else {
            char = self.input[self.readPosition];
            slice = self.input[self.readPosition .. self.readPosition + 1];
        }

        if (char == '=') {
            tok = Token.init(TokenType.ASSIGN, slice);
        } else if (char == ';') {
            tok = Token.init(TokenType.SEMICOLON, slice);
        } else if (char == '(') {
            tok = Token.init(TokenType.LPAREN, slice);
        } else if (char == ')') {
            tok = Token.init(TokenType.RPAREN, slice);
        } else if (char == ',') {
            tok = Token.init(TokenType.COMMA, slice);
        } else if (char == '+') {
            tok = Token.init(TokenType.PLUS, slice);
        } else if (char == '{') {
            tok = Token.init(TokenType.LBRACE, slice);
        } else if (char == '}') {
            tok = Token.init(TokenType.RBRACE, slice);
        } else if (char == 0) {
            tok = Token.init(TokenType.EOF, "");
        } else {
            if (isLetter(char)) {
                const literal = self.readIdentifier();
                tok = Token.init(TokenType.IDENT, literal);
            } else {
                tok = Token.init(TokenType.ILLEGAL, slice);
            }
        }

        self.moveNext();

        return tok;
    }
};

fn isLetter(char: u8) bool {
    return 'a' <= char and char <= 'z' or 'A' <= char and char <= 'Z' or char == '_';
}

test "test nextToken()" {
    const input =
        \\let five = 5;
        \\let ten = 10;
        \\let add = fn(x, y) {
        \\  x + y;
        \\};
        \\let result = add(five, ten);
    ;

    const tests = [_]Token{
        .{ .type = TokenType.LET, .literal = "let" },
        .{ .type = TokenType.IDENT, .literal = "five" },
        .{ .type = TokenType.ASSIGN, .literal = "=" },
        .{ .type = TokenType.INT, .literal = "5" },
        .{ .type = TokenType.SEMICOLON, .literal = ";" },
        .{ .type = TokenType.LET, .literal = "let" },
        .{ .type = TokenType.IDENT, .literal = "ten" },
        .{ .type = TokenType.ASSIGN, .literal = "=" },
        .{ .type = TokenType.INT, .literal = "10" },
        .{ .type = TokenType.SEMICOLON, .literal = ";" },
        .{ .type = TokenType.LET, .literal = "let" },
        .{ .type = TokenType.IDENT, .literal = "add" },
        .{ .type = TokenType.ASSIGN, .literal = "=" },
        .{ .type = TokenType.FUNCTION, .literal = "fn" },
        .{ .type = TokenType.LPAREN, .literal = "(" },
        .{ .type = TokenType.IDENT, .literal = "x" },
        .{ .type = TokenType.COMMA, .literal = "," },
        .{ .type = TokenType.IDENT, .literal = "y" },
        .{ .type = TokenType.RPAREN, .literal = ")" },
        .{ .type = TokenType.LBRACE, .literal = "(" },
        .{ .type = TokenType.IDENT, .literal = "x" },
        .{ .type = TokenType.PLUS, .literal = "+" },
        .{ .type = TokenType.IDENT, .literal = "y" },
        .{ .type = TokenType.SEMICOLON, .literal = ";" },
        .{ .type = TokenType.RBRACE, .literal = "}" },
        .{ .type = TokenType.SEMICOLON, .literal = ";" },
        .{ .type = TokenType.LET, .literal = "let" },
        .{ .type = TokenType.IDENT, .literal = "result" },
        .{ .type = TokenType.ASSIGN, .literal = "=" },
        .{ .type = TokenType.IDENT, .literal = "add" },
        .{ .type = TokenType.LPAREN, .literal = "(" },
        .{ .type = TokenType.IDENT, .literal = "five" },
        .{ .type = TokenType.COMMA, .literal = "," },
        .{ .type = TokenType.IDENT, .literal = "ten" },
        .{ .type = TokenType.RPAREN, .literal = ")" },
        .{ .type = TokenType.SEMICOLON, .literal = ";" },
        .{ .type = TokenType.EOF, .literal = "" },
    };

    var lexer = Lexer.init(input);

    for (tests) |current_test| {
        const tok = lexer.nextToken();

        std.debug.print("Current token type {s}\n", .{tok.type.toString()});
        std.debug.print("Current token literal {s}\n", .{tok.literal});

        try std.testing.expect(tok.type == current_test.type);
        try std.testing.expect(std.mem.eql(u8, tok.literal, current_test.literal));
    }
}
