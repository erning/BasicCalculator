//
//  ButtonView.swift
//  BasicCalculator
//
//  Created by Zhang Erning on 7/1/22.
//

import SwiftUI
import AppKit

struct KeyboardView: View {
    @EnvironmentObject var model: CalculatorViewModel

    var body: some View {
        VStack(spacing: 1) {
            HStack(spacing: 1) {
                ButtonView(label: model.calculator.hasInputingValue ? "C" : "AC", styleID: 2) {
                    model.press(
                        model.calculator.hasInputingValue ? .C : .AC
                    )
                }
                ButtonView(label: "⁺∕₋", styleID: 2) {
                    model.press(.signToggle)
                }
                ButtonView(label: "%", styleID: 2) {
                    model.press(.percent)
                }
                ButtonView(label: "÷", styleID: 1) {
                    model.press(.operation(.division))
                }
            }
            HStack(spacing: 1) {
                ButtonView(label: "7") {
                    model.press(.digit(7))
                }
                ButtonView(label: "8") {
                    model.press(.digit(8))
                }
                ButtonView(label: "9") {
                    model.press(.digit(9))
                }
                ButtonView(label: "×", styleID: 1) {
                    model.press(.operation(.multiplication))
                }
            }
            HStack(spacing: 1) {
                ButtonView(label: "4") {
                    model.press(.digit(4))
                }
                ButtonView(label: "5") {
                    model.press(.digit(5))
                }
                ButtonView(label: "6") {
                    model.press(.digit(6))
                }
                ButtonView(label: "−", styleID: 1) {
                    model.press(.operation(.substraction))
                }
            }
            HStack(spacing: 1) {
                ButtonView(label: "1") {
                    model.press(.digit(1))
                }
                ButtonView(label: "2") {
                    model.press(.digit(2))
                }
                ButtonView(label: "3") {
                    model.press(.digit(3))
                }
                ButtonView(label: "+", styleID: 1) {
                    model.press(.operation(.addition))
                }
            }
            HStack(spacing: 1) {
                ButtonView(label: "0", double: true) {
                    model.press(.digit(0))
                }
                ButtonView(label: ".") {
                    model.press(.decimelPoint)
                }
                ButtonView(label: "=", styleID: 1) {
                    model.press(.equal)
                }
            }
        }
//        .background(KeyAwareView())
    }
}

struct KeyAwareView: NSViewRepresentable {
    @EnvironmentObject var model: CalculatorViewModel

    func makeNSView(context: Context) -> NSView {
        let view = KeyView()
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

private class KeyView: NSView {
    override var acceptsFirstResponder: Bool { true }
    override func keyDown(with event: NSEvent) {
        print(event)
    }
}

struct ButtonView: View {

    var label: String?
    var styleID: Int = 0
    var double: Bool = false
    var action: () -> () = {}

    var body: some View {
        Button(action: action) {
            Text(label ?? "")
                .font(.title)
                .foregroundColor(.white)
        }
        .buttonStyle(
            CalculatorButtonStyle(styleID: styleID)
        )
        .frame(width: double ? 121 : 60, height: 50)
    }
}

struct CalculatorButtonStyle: ButtonStyle {
    static let colors: [(Color, Color)] = [
        (Color(nsColor: .gray), Color(nsColor: .lightGray)),
        (Color(nsColor: .systemOrange), Color(nsColor: .systemBrown)),
        (Color(nsColor: .darkGray), Color(nsColor: .gray))
    ]
    var styleID: Int = 0

    var defaultColor: Color { Self.colors[styleID].0 }
    var pressedColor: Color { Self.colors[styleID].1 }

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.isPressed ? pressedColor : defaultColor
            configuration.label
        }
        .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
   }
}

