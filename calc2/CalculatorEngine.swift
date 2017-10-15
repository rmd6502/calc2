//
//  CalculatorEngine.swift
//  calc2
//
//  Created by Robert Diamond on 10/14/17.
//  Copyright © 2017 Robert Diamond. All rights reserved.
//

import UIKit

enum Operator : String {
    case Plus = "+", Minus="-"
    case Multiply = "×", Divide = "÷"
    case Equal = "="
}

class CalculatorEngine: NSObject {
    public var value = 0.0
    var valueTemp = ""
    var valueStack = [Double]()
    var operatorStack = [Operator]()
    var lastOp : Operator?

    public func handleEvent(event : String) {
        switch event {
        case "±":
            if valueTemp.hasPrefix("-") {
                valueTemp.remove(at: valueTemp.startIndex)
            } else {
                if valueTemp.count > 0 {
                    valueTemp.insert("-", at: valueTemp.startIndex)
                }
            }
            value = Double(valueTemp) ?? 0.0
            lastOp = nil
        case "1/X":
            if value != 0 {
                value = 1/value
                valueTemp = ""
            }
            lastOp = nil
        case "0"..."9",".":
            if event != "." || valueTemp.index(of: ".") == nil {
                valueTemp += event
            }
            value = Double(valueTemp) ?? 0.0
            lastOp = nil
        case "Sqrt":
            if value > 0 {
                value = sqrt(value)
                valueTemp = ""
            }
            lastOp = nil
        case "+","-","×","÷":
            let op = Operator(rawValue: event)
            valueStack.insert(value, at: 0)
            // if we hit two operators in a row, pop the topmost operator from the stack
            if lastOp != nil && operatorStack.count > 0 {
                operatorStack.removeFirst()
            }
            collapseStack(event: op)
            valueTemp = ""
            value = valueStack[0]
            lastOp = op
        case "=":
            let op = Operator(rawValue: event)
            valueStack.insert(value, at: 0)
            collapseStack(event: op)
            valueTemp = ""
            value = valueStack[0]
            operatorStack = []
            valueStack = []
            lastOp = nil
        case "C":
            // first is clear entry
            if valueTemp == "" {
                operatorStack = []
                valueStack = []
            }
            valueTemp = ""
            value = 0.0
            lastOp = nil
        default:
            debugPrint("Unknown event " + event)
        }
    }

    func _prec(op : Operator) -> Int {
        switch op {
        case .Plus:
            return 0
        case .Minus:
            return 0
        case .Divide:
            return 1
        case .Multiply:
            return 1
        case .Equal:
            return -1
        }
    }

    func collapseStack(event : Operator?) {
        let prec = _prec(op: event!)
        while operatorStack.count > 0 && _prec(op: operatorStack[0]) >= prec {
            var ret = 0.0
            let a = valueStack.removeFirst()
            let b = valueStack.removeFirst()
            switch(operatorStack.removeFirst()) {
            case .Plus:
                ret = a + b
            case .Minus:
                ret = b - a
            case .Multiply:
                ret = b * a
            case .Divide:
                if a != 0 {
                    ret = b / a
                } else {
                    ret = b
                }
            case .Equal:
                break
            }
            valueStack.insert(ret, at: 0)
        }
        operatorStack.insert(event!, at: 0)
    }
}
