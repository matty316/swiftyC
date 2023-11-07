//
//  File.swift
//  
//
//  Created by matty on 11/7/23.
//

import Foundation

class Compiler {
    let programInstruction: ProgramInstruction
    let filename: String
    
    init(programInstruction: ProgramInstruction, filename: String) {
        self.programInstruction = programInstruction
        self.filename = filename
    }
    
    func emit() throws -> String {
        let string = programInstruction.function.emit()
        let assmFilename = filename.replacingOccurrences(of: ".i", with: ".s")
        let url = URL(fileURLWithPath: assmFilename)
        try string.write(to: url, atomically: false, encoding: .ascii)
        return string
    }
}
