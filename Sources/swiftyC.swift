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
                let tokens = try lex(source: source)
                print(tokens)
            } else if parse {
                let tokens = try lex(source: source)
                let program = try parse(tokens: tokens)
                print(program.print())
            } else if codegen {
                let tokens = try lex(source: source)
                let program = try parse(tokens: tokens)
                try codegen(program: program)
            } else {
                let tokens = try lex(source: source)
                let program = try parse(tokens: tokens)
                let programInstruction = try codegen(program: program)
                let c = Compiler(programInstruction: programInstruction, filename: filename)
                print(try c.emit())
            }
        } catch let error as LexerError {
            print(error.message)
            Self.exit(withError: ExitCode(65))
        } catch let error as ParserError {
            print(error.message)
            Self.exit(withError: ExitCode(65))
        } catch {
            print(error.localizedDescription)
            Self.exit(withError: ExitCode(65))
        }
    }
    
    @discardableResult
    func lex(source: String) throws -> [Token] {
        let l = Lexer(source: source)
        return try l.scan()
    }
    
    @discardableResult
    func parse(tokens: [Token]) throws -> Program {
        let p = Parser(tokens: tokens)
        return try p.parse()
    }
    
    @discardableResult
    func codegen(program: Program) throws -> ProgramInstruction {
        let ap = AssemblyParser(program: program)
        return try ap.parse()
    }
}
