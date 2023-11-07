//
//  token.swift
//
//
//  Created by matty on 11/6/23.
//

import Foundation

enum TokenType {
    case Ident, Const, Int, Void, Return, LParen, RParen, LBrace, RBrace, Semicolon, Eof
}

struct Token {
    let tokenType: TokenType
    let lexeme: String
    let line: Int
    let literal: Any?
}
