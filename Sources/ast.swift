//
//  ast.swift
//  
//
//  Created by matty on 11/6/23.
//

import Foundation

protocol Expr {
    func print() -> String
}
protocol Stmt {
    func print() -> String
}

struct Program {
    let function: Function
    func print() -> String {
        "Program -> \(function.print())"
    }
}

struct Function: Expr {
    let ident: Ident
    let body: Stmt
    func print() -> String {
        "Function \(ident.print()) -> \(body.print())"
    }
}

struct Ident: Expr {
    let name: String
    func print() -> String {
        name
    }
}

struct Return: Stmt {
    let expr: Expr
    func print() -> String {
        "return \(expr.print())"
    }
}

struct Constant: Expr {
    let val: Int
    func print() -> String {
        "\(val)"
    }
}

