//
//  parser.swift
//
//
//  Created by matty on 11/6/23.
//

import Foundation

struct ParserError: Error {
    let message: String
}

class Parser {
    private let tokens: [Token]
    private var current = 0
    private var currentToken: Token {
        tokens[current]
    }
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    func parse() throws -> Program {
        var program: Program? = nil
        
        let function = try parseFunction()
        
        program = Program(function: function)
        guard let program = program else {
            throw ParserError(message: "unable to parse program")
        }
        return program
    }
    
    func parseFunction() throws -> Function {
        try expect(tokenType: .Int)
        let name = try parseIdent()
        
        try expect(tokenType: .LParen)
        try expect(tokenType: .Void)
        try expect(tokenType: .RParen)
        
        while currentToken.tokenType != .LBrace {
            advance()
        }
        
        try expect(tokenType: .LBrace)
        
        let returnStmt = try parseReturn()
        
        try expect(tokenType: .RBrace)
        try expect(tokenType: .Eof)
        
        return Function(ident: name, body: returnStmt)
    }
    
    func parseIdent() throws -> Ident {
        let ident = try expect(tokenType: .Ident)
        return Ident(name: ident.lexeme)
    }
    
    func parseReturn() throws -> Return {
        try expect(tokenType: .Return)
        let expr = try parseExpr()
        try expect(tokenType: .Semicolon)
        return Return(expr: expr)
    }
    
    func parseExpr() throws -> Expr {
        let token = try expect(tokenType: .Const)
        guard let val = token.literal as? Int else {
            throw ParserError(message: "expected an constant got \(token.tokenType) at line \(token.line)")
        }
        return Constant(val: val)
    }
}

//MARK: Helpers
private extension Parser {
    @discardableResult
    func advance() -> Token {
        if current < tokens.count {
            let token = currentToken
            current += 1
            return token
        }
        return tokens[current]
    }
    
    @discardableResult
    func expect(tokenType: TokenType) throws -> Token {
        if tokenType == currentToken.tokenType {
            return advance()
        }
        throw ParserError(message: "expected \(tokenType) got \(currentToken.tokenType) at line \(currentToken.line)")
    }
}
