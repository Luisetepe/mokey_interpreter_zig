const std = @import("std");
const lexer = @import("lexer.zig");
const Lexer = lexer.Lexer;
const TokenType = @import("token.zig").TokenType;
pub fn main() !void {
    const input = "let five = 5;";
    var myLexer = Lexer.init(input);
    var token = myLexer.nextToken();

    while (token.type != TokenType.EOF) : (token = myLexer.nextToken()) {
        std.debug.print("Token: {s}\n", .{token.literal});
    }
}
