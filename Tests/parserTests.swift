//
//  parserTests.swift
//  
//
//  Created by matty on 11/6/23.
//

import XCTest
@testable import swiftyC

final class parserTests: XCTestCase {
    
    func testParser() throws {
        let source = """
        int main(void) {
          return 400;
        }
        """
        
        let l = Lexer(source: source)
        let tokens = try l.scan()
        let p = Parser(tokens: tokens)
        let program = try p.parse()
        print(program.print())
        let function = program.function
        XCTAssertEqual(function.ident.name, "main")
        let body = function.body as! Return
        let constant = body.expr as! Constant
        XCTAssertEqual(constant.val, 400)
    }
}
