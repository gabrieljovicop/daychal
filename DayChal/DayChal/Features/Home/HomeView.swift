//
//  HomeView.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import SwiftUI
import Supabase

struct HomeView: View {
    
    @EnvironmentObject var session: SessionManager
    @StateObject private var vm = HomeViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 24) {
                    headerCard
                    categoryScroller
                    
                    if vm.isLoading {
                        ProgressView().padding(.top, 50)
                    } else {
                        let filtered = vm.getFilteredChallenges(ongoingIds: session.ongoingChallengeIds)
                        
                        if filtered.isEmpty {
                            ContentUnavailableView(
                                "No Results",
                                systemImage: "line.3.horizontal.decrease.circle",
                                description: Text("No challenges match your selected filters.")
                            )
                            .padding(.top, 50)
                        } else {
                            VStack(spacing: 16) {
                                ForEach(filtered) { challenge in
                                    ChallengeRow(challenge: challenge, source: .home)
                                }
                            }
                        }
                    }
                }
                .padding(24)
            }
            
            myChallengeFAB
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                filterMenu
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ProfileView(user: session.user, profile: session.profile)
                } label: {
                    Image(systemName: "person.crop.circle")
                }
            }
        }
        .onAppear {
            vm.bindProfile(session.profile)
            Task { await vm.loadChallenges() }
        }
    }
}

private extension HomeView {
    var filterMenu: some View {
        Menu {
            Section("Filter by Difficulty") {
                Button {
                    vm.selectedDifficulty = nil
                } label: {
                    HStack {
                        Text("All Difficulties")
                        if vm.selectedDifficulty == nil { Image(systemName: "checkmark") }
                    }
                }
                
                ForEach(ChallengeDifficulty.allCases) { diff in
                    Button {
                        vm.selectedDifficulty = diff
                    } label: {
                        HStack {
                            Text(diff.rawValue.capitalized)
                            if vm.selectedDifficulty == diff { Image(systemName: "checkmark") }
                        }
                    }
                }
            }
        } label: {
            Image(systemName: vm.selectedDifficulty == nil ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                .foregroundColor(vm.selectedDifficulty == nil ? .primary : .orange)
        }
    }

    var challengeList: some View {
        VStack(spacing: 16) {
            let ongoingIds = session.ongoingChallengeIds
            
            ForEach(vm.getFilteredChallenges(ongoingIds: ongoingIds)) { challenge in
                ChallengeRow(challenge: challenge, source: .home)
            }
        }
    }
    
    var myChallengeFAB: some View {
        NavigationLink {
            MyChallengeView()
        } label: {
            HStack {
                Image(systemName: "list.bullet.rectangle.portrait.fill")
                Text("My Challenge").bold()
            }
            .padding(.vertical, 12).padding(.horizontal, 20)
            .background(.black).foregroundColor(.white)
            .clipShape(Capsule()).shadow(radius: 4)
        }
        .padding(24)
    }
    
    var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hello, \(vm.username)")
                .font(.title2.bold())
            Text("ChalPoin").font(.caption).foregroundColor(.gray)
            Text("\(vm.myChalPoin) poin").font(.title.bold())
        }
        .padding(24).frame(maxWidth: .infinity, alignment: .leading)
        .background(.white).cornerRadius(16).shadow(radius: 2)
    }
    
    var categoryScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(vm.categories) { category in
                    CategoryChip(
                        title: category.title,
                        isSelected: vm.selectedCategory == category
                    ) {
                        vm.selectedCategory = category
                    }
                }
            }
        }
    }
}
