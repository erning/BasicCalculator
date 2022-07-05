//
//  CalculatorModel.swift
//  BasicCalculator
//
//  Created by Zhang Erning on 7/1/22.
//

import Foundation
import AppKit
import Calculator

class CalculatorViewModel: ObservableObject {
    let calculator: Calculator = .init()
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumSignificantDigits = 8
        return formatter
    }()

    @Published var screenValue: String = "0"

    func press(_ key: Calculator.Button) {
        calculator.press(key)
        updateScreenValue()
    }

    func updateScreenValue() {
        var value = formatter.string(for: calculator.display)!
        if let exp = calculator.exponent {
            if exp == 0 {
                value += "."
            } else if calculator.significand.isZero {
                value += "."
                for _ in exp..<0 {
                    value += "0"
                }
            }
        }
        if calculator.sign == .minus && calculator.display.isZero {
            value = "-" + value
        }
        screenValue = value
    }
}
