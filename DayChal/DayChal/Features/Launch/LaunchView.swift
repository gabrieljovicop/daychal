//
//  LaunchView.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

struct LaunchView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 20) {
                Image("DayChalLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .opacity(isAnimating ? 1.0 : 0.0)

                Text("DayChal")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .tracking(2)
                    .opacity(isAnimating ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                isAnimating = true
            }
        }
    }
}
