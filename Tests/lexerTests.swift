//
//  lexerTests.swift
//  
//
//  Created by matty on 11/6/23.
//

import XCTest
@testable import swiftyC

final class lexerTests: XCTestCase {

    func testLexer() {
        let source = """
        int main (void) {
          return 4;
        }

        """
        
        let l = Lexer(source: source)
        
    }

}
