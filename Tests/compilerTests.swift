//
//  compilerTests.swift
//  
//
//  Created by matty on 11/7/23.
//

import XCTest
@testable import swiftyC

final class compilerTests: XCTestCase {

    func testCodeEmition() throws {
        let source = """
        int main(void) {
          return 400;
        }

        """
        
        let l = Lexer(source: source)
        let p = Parser(tokens: try l.scan())
        let ap = AssemblyParser(program: try p.parse())
        let prgmInst = try ap.parse()
        print(prgmInst.function.emit())
    }

}
