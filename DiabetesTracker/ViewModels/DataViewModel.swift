//
//  DataViewModel.swift
//  DiabetesTracker
//
//  Created by Megan on 11/21/25.
//

import SwiftUI
import Supabase

@MainActor
class DataViewModel: ObservableObject {
    @Published var entries: [GlucoseEntryDTO] = []
    
    private let client = SupabaseService.shared.client
    
    
    func fetchEntries() async throws -> [GlucoseEntry] {
//        do {
            let dtos: [GlucoseEntryDTO] = try await client
                .from("glucose_logs")
                .select()
                .execute()
                .value
        return dtos.map { GlucoseEntry(from: $0) }
//            let response = try await client
//                .from("glucose_logs")
//                .select("*")
//                .execute()
//            
//            if let rows = response.value as? [[String: Any]] {
//                // convert to SwiftData GlcuoseEntry
//                for dict in rows {
//                    let entry = GlucoseEntry(
//                        id: dict["id"] as? Int ?? 0,
//                        time: ISO8601DateFormatter().date(from: dict["time"] as? String ?? "") ?? Date(),
//                        glucoseValue: dict["glucose_value"] as? Int ?? 0,
//                        glucoseType: GlucoseType(rawValue: dict["glucose_type"] as? String ?? "fasting") ?? .fasting,
//                        notes: dict["notes"] as? String ?? ""
//                    )
//                }
//            } else {
//                return
//            }
//            self.entries = response.value ?? []
//        } catch {
//            print("Error fetching entries:", error)
//        }
    }
}
