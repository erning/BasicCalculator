import Foundation

public class Calculator {
    var tokens: [Token] = []

    public init() {
        
    }

    // the value shown on screen
    public var display: Decimal {
        if let v = pendingOperand {
            return v
        }
        if let o1 = pendingOperation, let o2 = recentOperation {
            if o1.order > o2.order {
                return recentOperand ?? 0
            }
        }
        return evaluate()
    }

    var pendingOperation: Operation? = nil
    var pendingOperand: Decimal? {
        guard hasInputingValue else { return nil }
        return Decimal(sign: sign, exponent: exponent ?? 0, significand: significand)
    }

    public var hasInputingValue: Bool = false
    public var sign: FloatingPointSign = .plus
    public var exponent: Int? = nil
    public var significand: Decimal = 0

    var recentOperand: Decimal?
    var recentOperation: Operation?

    public func press(_ button: Button) {
        switch button {
        case .digit(let digit):
            handleOperation()
            if hasInputingValue {
                significand = significand * 10 + Decimal(digit)
                if let v = exponent {
                    exponent = v - 1
                }
            } else {
                sign = .plus
                exponent = nil
                significand = Decimal(digit)
                hasInputingValue = true
            }
        case .decimelPoint:
            handleOperation()
            if !hasInputingValue {
                sign = .plus
                exponent = nil
                significand = 0
                hasInputingValue = true
            }
            if exponent == nil {
                exponent = 0
            }
        case .signToggle:
            handleOperation()
            if !hasInputingValue {
                if pendingOperation == nil {
                    let v = display
                    sign = v.sign
                    exponent = v.exponent == 0 ? nil : v.exponent
                    significand = v.significand
                    hasInputingValue = true
                } else {
                    sign = .plus
                    exponent = nil
                    significand = 0
                }
                hasInputingValue = true
            }
            sign = sign == .plus ? .minus : .plus
            break
        case .percent:
            handleOperation()
            if !hasInputingValue {
                let v = display
                sign = v.sign
                exponent = v.exponent == 0 ? nil : v.exponent
                significand = v.significand
                hasInputingValue = true
            } else if let v = pendingOperand {
                if v.isZero {
                    break
                }
            }
            if exponent == nil {
                exponent = -2
            } else {
                exponent! -= 2
            }
            break
        case .operation(let operation):
            handleOperand()
            pendingOperation = operation
            break
        case .equal:
            if hasInputingValue == false {
                if let op = pendingOperation {
                    tokens.append(.operation(op))
                    tokens.append(.operand(display))
                    pendingOperation = nil
                } else {
                    if let v = recentOperand, let o = recentOperation {
                        tokens.append(.operation(o))
                        tokens.append(.operand(v))
                    }
                }
            } else {
                handleOperand()
            }
            let v = evaluate()
            tokens.removeAll()
            tokens.append(.operand(v))
            break
        case .AC:
            tokens.removeAll()
            hasInputingValue = false
            pendingOperation = nil
            recentOperation = nil
            recentOperand = nil
            break
        case .C:
            hasInputingValue = false
            pendingOperation = recentOperation
            break
        }
    }

    private func handleOperation() {
        if let op = pendingOperation {
            tokens.append(.operation(op))
            recentOperation = pendingOperation
            pendingOperation = nil
        }
    }

    private func handleOperand() {
        if let v = pendingOperand {
            tokens.append(.operand(v))
            recentOperand = v
            hasInputingValue = false
        }
    }

    func evaluate() -> Decimal {
        // to reverse polish notation
        var rpn: [Token] = []
        var ops: [Operation] = []
        for token in tokens {
            switch token {
            case .operand:
                rpn.append(token)
            case .operation(let op):
                while let prev = ops.last {
                    if prev.order < op.order {
                        break
                    }
                    _ = ops.popLast()
                    rpn.append(.operation(prev))
                }
                ops.append(op)
            }
        }
//        if let op = pendingOperation {
//            while let prev = ops.last {
//                if prev.order < op.order {
//                    break
//                }
//                _ = ops.popLast()
//                rpn.append(.operation(prev))
//            }
//            ops.append(op)
//        }
        while let op = ops.popLast() {
            rpn.append(.operation(op))
        }

        // evaluate
        var stack: [Decimal] = []
        for token in rpn {
            switch token {
            case .operand(let v):
                stack.append(v)
            case .operation(let o):
                if stack.isEmpty { break }
                let b = stack.popLast()!
                let a = stack.popLast() ?? 0
                let c = o.evaluate(a, b)
                stack.append(c)
            }
        }
        return stack.last ?? 0
    }
}

extension Calculator: CustomStringConvertible {
    public var description: String {
        var s = "\(display)"
        if !tokens.isEmpty {
            s += ", tokens: \(tokens)"
        }
        if let operand = pendingOperand {
            s += ", operand: \(operand)"
        }
        if let operation = pendingOperation {
            s += ", operation: \(operation)"
        }
        if let operand = recentOperand {
            s += ", recentOperand: \(operand)"
        }
        if let operation = recentOperation {
            s += ", recentOperation: \(operation)"
        }
        return s
    }
}

extension Calculator {
    public enum Button {
        case AC, C
        case digit(Int)
        case decimelPoint
        case signToggle
        case percent
        case operation(Operation)
        case equal
    }

    public enum Token: CustomDebugStringConvertible {
        case operand(Decimal)
        case operation(Operation)

        public var debugDescription: String {
            switch self {
            case .operand(let v):
                return "\(v)"
            case .operation(let o):
                return "\(o)"
            }
        }
    }

    public struct Operation: CustomDebugStringConvertible {

        let symbol: String
        let order: Int
        let evaluate: (Decimal, Decimal) -> Decimal

        public var debugDescription: String {
            return symbol
        }

        public static let addition = Operation(symbol: "+", order: 1) { $0 + $1 }
        public static let substraction = Operation(symbol: "-", order: 1) { $0 - $1 }
        public static let multiplication = Operation(symbol: "*", order: 2) { $0 * $1 }
        public static let division = Operation(symbol: "/", order: 2) { $0 / $1 }
    }
}
