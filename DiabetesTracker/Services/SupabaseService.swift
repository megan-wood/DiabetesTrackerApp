//
//  SupabaseService.swift
//  DiabetesTracker
//
//  Created by Megan on 11/19/25.
//

import Supabase
import Foundation


class SupabaseService {
    static let shared = SupabaseService()
    
    private let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://tnjwlqnipgfxvbgfehng.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRuandscW5pcGdmeHZiZ2ZlaG5nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2NTA1MDIsImV4cCI6MjA2ODIyNjUwMn0.2Ajg9viCUvHW7y2FGmHIh97XcGCfuJ3ZtdCU3X2jutE"
    )
    
    //struct UserEntry: Decodable, Identifiable {
    //    let id: Int
    //    let firstName: String
    //    let lastName: String
    //}
    
    func fetchGlucoseEntries() async throws -> [GlucoseEntryDTO] {
        try await supabase
            .from("glucose_logs")
            .select()
            .execute()
            .value
        
    }
}
