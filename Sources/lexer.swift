//
//  lexer.swift
//
//
//  Created by matty on 11/6/23.
//

import Foundation

class Lexer {
    let source: String
    let start: String.Index
    let current: String.Index
    
    init(source: String) {
        self.source = source
        self.start = self.source.startIndex
        self.current = self.source.startIndex
    }
}
