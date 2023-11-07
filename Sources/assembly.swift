//
//  assembly.swift
//
//
//  Created by matty on 11/7/23.
//

import Foundation

protocol Instruction {
    func emit() -> String
}
protocol Operand {
    func emit() -> String
}

struct ProgramInstruction {
    let function: FunctionInstruction
}

struct FunctionInstruction: Instruction {
    let name: String
    let instructions: [Instruction]
    func emit() -> String {
        """
    .globl _\(name)
_\(name):
    \(instructions.map { $0.emit() }.joined(separator: "\n\t"))
"""
    }
}

struct MovInstruction: Instruction {
    let src: Operand
    let dst: Operand
    func emit() -> String {
        "movl   \(src.emit()), \(dst.emit())"
    }
}

struct RetInstruction: Instruction {
    func emit() -> String {
        "ret"
    }
}

struct Imm: Operand {
    let val: Int
    func emit() -> String {
        "$\(val)"
    }
}

struct Register: Operand {
    func emit() -> String {
        "%eax"
    }
}
