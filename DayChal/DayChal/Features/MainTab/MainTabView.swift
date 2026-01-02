//
//  MainTabView.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {

            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NavigationStack {
                ExchangeView()
            }
            .tabItem {
                Image(systemName: "arrow.left.arrow.right")
                Text("Exchange")
            }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Image(systemName: "clock.fill")
                Text("History")
            }
        }
        .tint(.blue)
    }
}
