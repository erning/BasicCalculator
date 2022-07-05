//
//  BasicCalculatorApp.swift
//  BasicCalculator
//
//  Created by Zhang Erning on 7/1/22.
//

import SwiftUI

@main
struct BasicCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorView()
                .environmentObject(CalculatorViewModel())
        }
    }
}
