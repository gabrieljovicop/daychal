//
//  DayChalApp.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

@main
struct DayChalApp: App {
    
    @StateObject private var sessionManager = SessionManager()
    var body: some Scene {
        WindowGroup {
            RootView().environmentObject(sessionManager)
        }
    }
}
