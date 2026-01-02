//
//  SessionManager.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Foundation
import Supabase

@MainActor
final class SessionManager: ObservableObject {

    @Published var flow: AppFlow = .launching
    @Published var user: User?
    @Published var profile: Profile?
    @Published var userHistory: [ChallengeHistory] = []

    let client = SupabaseManager.shared.client
//    private var authTask: Task<Void, Never>?

    init() {
        setupAuthListener()
//        Task {
//            await restoreSession()
//        }
    }
    
    var ongoingChallengeIds: [UUID] {
        userHistory
            .filter { $0.status == .onGoing }
            .map { $0.challengeId }
    }
    
    func setupAuthListener() {
        Task { //sebelumnya authTask = Task {
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            for await (event, session) in client.auth.authStateChanges {
                print("Auth Event: \(event)")
                
                if let session = session {
                    self.user = session.user
                    await fetchProfile()
                    self.flow = .authenticated
                } else {
                    self.user = nil
                    self.profile = nil
                    self.flow = .unauthenticated
                }
            }
        }
    }

    func fetchProfile() async {
        guard let userId = user?.id else { return }
        do {
            let fetchedProfile: Profile = try await client
                .from("profiles")
                .select()
                .eq("id", value: userId.uuidString)
                .single()
                .execute()
                .value
            self.profile = fetchedProfile
        } catch {
            print("Fetch profile error: \(error)")
        }
    }
//    func restoreSession() async {
//        do {
//            let session = try await client.auth.session
//            self.user = session.user
//            await fetchProfile()
//            self.flow = .authenticated
//        } catch {
//            self.flow = .unauthenticated
//        }
//    }
    
    func refreshProfile() async {
        await fetchProfile()
    }

    func logout() async {
        try? await client.auth.signOut()
    }
}
