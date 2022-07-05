//
//  ScreenView.swift
//  BasicCalculator
//
//  Created by Zhang Erning on 7/1/22.
//

import SwiftUI

struct ScreenView: View {
    @EnvironmentObject var model: CalculatorViewModel

    var body: some View {
            Text("\(model.screenValue)")
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 233, height: 50, alignment: .trailing)
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
            .background(Color.black)
            .environmentObject(CalculatorViewModel())
    }
}
