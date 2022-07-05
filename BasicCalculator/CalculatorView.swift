//
//  ContentView.swift
//  BasicCalculator
//
//  Created by Zhang Erning on 7/1/22.
//

import SwiftUI

struct CalculatorView: View {
    var body: some View {
        ZStack {
            Color.black
            VStack(spacing: 0) {
                ScreenView()
                KeyboardView()
            }
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
            .environmentObject(CalculatorViewModel())
    }
}
