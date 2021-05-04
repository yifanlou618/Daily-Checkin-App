//
//  CustomStyle.swift
//  DAKA
//
//  Created by HLi on 4/29/21.
//

import SwiftUI

// Custom Button Style
struct NeumorphicButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .bold))
            .padding(20)
            .background(Color(red: 0, green: 0.5, blue: 0.9))
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .cornerRadius(7.0)
            .foregroundColor(.white)
            .animation(.spring())
    }
}

struct AlertButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .bold))
            .padding(20)
            .background(Color(red: 0.8, green: 0, blue: 0))
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .cornerRadius(7.0)
            .foregroundColor(.white)
            .animation(.spring())
    }
}
