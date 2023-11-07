//
//  lexerTests.swift
//  
//
//  Created by matty on 11/6/23.
//

import XCTest
@testable import swiftyC

final class lexerTests: XCTestCase {

    func testLexer() throws {
        let source = """
        int main(void) {
          return 400;
        }

        """
        
        let l = Lexer(source: source)
        let tokens = try l.scan()
        
        let exp = [
            Token(tokenType: .Int, lexeme: "int", line: 1, literal: nil),
            Token(tokenType: .Ident, lexeme: "main", line: 1, literal: nil),
            Token(tokenType: .LParen, lexeme: "(", line: 1, literal: nil),
            Token(tokenType: .Void, lexeme: "void", line: 1, literal: nil),
            Token(tokenType: .RParen, lexeme: ")", line: 1, literal: nil),
            Token(tokenType: .LBrace, lexeme: "{", line: 1, literal: nil),
            Token(tokenType: .Return, lexeme: "return", line: 2, literal: nil),
            Token(tokenType: .Const, lexeme: "400", line: 2, literal: 400),
            Token(tokenType: .Semicolon, lexeme: ";", line: 2, literal: nil),
            Token(tokenType: .RBrace, lexeme: "}", line: 3, literal: nil),
            Token(tokenType: .Eof, lexeme: "", line: 4, literal: nil)
        ]
        
        XCTAssertEqual(exp.count, tokens.count)
        
        for (i, t) in tokens.enumerated() {
            let e = exp[i]
            XCTAssertEqual(t.lexeme, e.lexeme)
            XCTAssertEqual(t.tokenType, e.tokenType)
            XCTAssertEqual(t.line, e.line)
            if let literal = t.literal as? Int, let expLit = e.literal as? Int {
                XCTAssertEqual(literal, expLit)
            }
        }
    }
    
    func testInvalid() {
        let sources = [
            "1foo",
            "@b",
            "`",
            "\\",
            "0@1",
        ]
        
        for s in sources {
            let l = Lexer(source: s)
            
            do {
                _ = try l.scan()
                XCTFail()
            } catch {
                XCTAssert(true)
            }
        }
    }
}
