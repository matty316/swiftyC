// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import ArgumentParser

@main
struct SwiftyC: ParsableCommand {
    @Flag(help: "only run lexer")
    var lex = false
    
    @Flag(help: "only run lexer and parse")
    var parse = false
    
    @Flag(help: "only run lexer, parser and codegen")
    var codegen = false
    
    @Flag(name: .short, help: "emit assembly file")
    var S = false
    
    @Argument(help: "filename of c file")
    var filename: String
    
    mutating func run() {
        let url = URL(fileURLWithPath: filename)
        do {
            let source = try String(contentsOf: url)
            if lex {
                lex(source: source)
            } else if parse {
                lex(source: source)
                // parse
                print("no lex")
            } else if codegen {
                lex(source: source)
                // parse
                // codegen
            } else {
                lex(source: source)
                // BITCH EVERYTHING
            }
        } catch {
            Self.exit(withError: ExitCode(65))
        }
    }
    
    func lex(source: String) {
        let l = Lexer(source: source)
        
    }
}
