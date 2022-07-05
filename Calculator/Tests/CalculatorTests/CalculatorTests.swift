import XCTest
@testable import Calculator

extension Calculator {
    func press(_ chars: String) {
        for ch in chars {
            switch ch {
            case "0"..."9":
                press(.digit(ch.wholeNumberValue!))
            case ".":
                press(.decimelPoint)
            case "+":
                press(.operation(.addition))
            case "-":
                press(.operation(.substraction))
            case "*":
                press(.operation(.multiplication))
            case "/":
                press(.operation(.division))
            case "=":
                press(.equal)
            default:
                break
            }
        }
    }
}

final class CalculatorTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(true, true)
    }

    func testBasic() {
        let calculator = Calculator()
        XCTAssertEqual(calculator.display, 0)
        calculator.press(.digit(1))
        calculator.press(.digit(2))
        calculator.press(.decimelPoint)
        XCTAssertEqual(calculator.display, 12)
        calculator.press(.digit(3))
        XCTAssertEqual(calculator.display, 12.3)
    }

    func testChangeOperation() {
        let calculator = Calculator()
        calculator.press("5+2+")
        XCTAssertEqual(calculator.display, 7)
        calculator.press("*")
        XCTAssertEqual(calculator.display, 2)
        calculator.press("=")
        XCTAssertEqual(calculator.display, 9)
        calculator.press("+2=")
        XCTAssertEqual(calculator.display, 11)
    }

    func testOperationThenEqual() {
        let calculator = Calculator()
        calculator.press("2+3+")
        XCTAssertEqual(calculator.display, 5)
        calculator.press("=")
        XCTAssertEqual(calculator.display, 10)
    }

    func testRepeatLast() {
        let calculator = Calculator()
        calculator.press("2+3=")
        XCTAssertEqual(calculator.display, 5)
        calculator.press("=")
        XCTAssertEqual(calculator.display, 8)
    }

    func testDisplayOperand() {
        let calculator = Calculator()
        calculator.press("2+3=")
        XCTAssertEqual(calculator.display, 5)
        calculator.press("+=")
        XCTAssertEqual(calculator.display, 10)
    }

    func testSignToggle() {
        let calculator = Calculator()
        calculator.press("4*2=")
        print(calculator)
        calculator.press("=")
        print(calculator)
    }
}
