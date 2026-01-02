//
//  SupabaseManager.swift
//  DayChal
//
//  Created by prk on 13/12/25.
//

import Supabase
import Foundation

final class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://jlgonilgjmihjdeezzbf.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpsZ29uaWxnam1paGpkZWV6emJmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU1NzI1NzQsImV4cCI6MjA4MTE0ODU3NH0.NqBRyx6FImfMEfjE7NZy2EtN43zmKcB2KyWjxTbMDuk"
        )
    }
}
