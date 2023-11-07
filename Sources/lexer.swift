//
//  lexer.swift
//
//
//  Created by matty on 11/6/23.
//

import Foundation

struct LexerError: Error {
    let message: String
}

class Lexer {
    let source: String
    var start: String.Index
    var current: String.Index
    var line: Int
    
    init(source: String) {
        self.source = source
        self.start = self.source.startIndex
        self.current = self.source.startIndex
        self.line = 1
    }
    
    func scan() throws -> [Token] {
        var tokens = [Token]()
        while !isAtEnd() {
            start = current
            let c = advance()
            
            switch c {
            case "(": tokens.append(makeToken(tokenType: .LParen))
            case ")": tokens.append(makeToken(tokenType: .RParen))
            case "{": tokens.append(makeToken(tokenType: .LBrace))
            case "}": tokens.append(makeToken(tokenType: .RBrace))
            case ";": tokens.append(makeToken(tokenType: .Semicolon))
            case " ", "\t", "\r": break
            case "/":
                while peek() != "\n" {
                    advance()
                }
            case "\n":
                line += 1
                break
            default:
                if isAlpha(c: c) {
                    tokens.append(ident())
                } else if isDigit(c: c) {
                    tokens.append(try num())
                } else {
                    throw LexerError(message: "illegal token \(c) at \(line)")
                }
            }
        }
        tokens.append(Token(tokenType: .Eof, lexeme: "", line: line, literal: nil))
        return tokens
    }
}

private extension Lexer {
    @discardableResult
    func advance() -> Character {
        if current == source.endIndex { return "\0" }
        let prev = current
        current = source.index(after: current)
        return source[prev]
    }
    
    func peek() -> Character {
        if current == source.endIndex { return "\0" }
        return source[current]
    }
    
    func isAtEnd() -> Bool {
        current == source.endIndex
    }
    
    func makeToken(tokenType: TokenType) -> Token {
        let lexeme =  String(source[start..<current])
        return Token(tokenType: tokenType, lexeme: lexeme, line: line, literal: nil)
    }
    
    func isDigit(c: Character) -> Bool {
        c >= "0" && c <= "9"
    }
    
    func isAlpha(c: Character) -> Bool {
        c >= "a" && c <= "z" || c >= "A" && c <= "Z" || c == "_"
    }
    
    func ident() -> Token {
        while isAlpha(c: peek()) || isDigit(c: peek()) {
            advance()
        }
        
        let lexeme = String(source[start..<current])
        return lookupKeyword(lexeme: lexeme)
    }
    
    func lookupKeyword(lexeme: String) -> Token {
        let c = source[start]
        switch c {
        case "i": return checkKeyword(rest: "nt", begin: 1, len: 2, token: makeToken(tokenType: .Int))
        case "v": return checkKeyword(rest: "oid", begin: 1, len: 3, token: makeToken(tokenType: .Void))
        case "r": return checkKeyword(rest: "eturn", begin: 1, len: 5, token: makeToken(tokenType: .Return))
        default: break
        }
        
        return makeToken(tokenType: .Ident)
    }
    
    func checkKeyword(rest: String, begin: Int, len: Int, token: Token) -> Token {
        if source[start..<current].count == begin + len && String(source[source.index(start, offsetBy: begin)..<current]) == rest {
            return token
        }
        return makeToken(tokenType: .Ident)
    }
    
    func num() throws -> Token {
        while isDigit(c: peek()) {
            advance()
        }
        
        if isAlpha(c: peek()) {
            throw LexerError(message: "invalid identifier")
        }
        
        let lexeme = String(source[start..<current])
        return Token(tokenType: .Const, lexeme: lexeme, line: line, literal: Int(lexeme))
    }
}
