//
//  File.swift
//  
//
//  Created by matty on 11/7/23.
//

import Foundation

class AssemblyParser {
    let program: Program
    
    init(program: Program) {
        self.program = program
    }
    
    func parse() throws -> ProgramInstruction {
        let function = program.function
        let ret = RetInstruction()
        guard let returnExpr = function.body as? Return, let constant = returnExpr.expr as? Constant else {
            throw ParserError(message: "cannot parse return")
        }
        let mov = MovInstruction(src: Imm(val: constant.val), dst: Register())
        let functionInstruction = FunctionInstruction(name: function.ident.name, instructions: [mov, ret])
        return ProgramInstruction(function: functionInstruction)
    }
}
