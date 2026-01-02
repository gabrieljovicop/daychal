//
//  RootView.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject var session: SessionManager

    var body: some View {
        Group {
            switch session.flow {
            case .launching:
                LaunchView()
            case .unauthenticated:
                LoginView()
            case .authenticated:
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: session.flow)
    }
}
