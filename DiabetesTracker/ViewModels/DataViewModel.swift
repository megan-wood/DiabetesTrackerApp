//
//  DataViewModel.swift
//  DiabetesTracker
//
//  Created by Megan on 11/21/25.
//

import SwiftUI
import Supabase
import Foundation

@MainActor
class DataViewModel: ObservableObject {
    @Published var entries: [GlucoseEntry] = []
    private var channel: RealtimeChannelV2?
    
    private let client = SupabaseService.shared.client
    
    init() {
        Task {
            await load()
        }
        subscribeToRealtime()
    }
    
//    deinit {
//        channel?.unsubscribe()
//        print("realtime channel unsubscribed")
//    }
    
    func load() async {
        do {
            print("Loading entries")
            let items = try await fetchEntries()
            DispatchQueue.main.async {
                self.entries = items
            }
        } catch {
            print("Error loading entries:", error)
        }
    }
    
    func fetchEntries() async throws -> [GlucoseEntry] {
        //        do {
        let dtos: [GlucoseEntryDTO] = try await client
            .from("glucose_logs")
            .select()
            .execute()
            .value
        return dtos.map { GlucoseEntry(from: $0) }
    }
    
    func subscribeToRealtime() {
        let channel = client.channel("glucose-realtime")
        
        let subscription = channel.onPostgresChange(
                AnyAction.self,
                schema: "public",
                table: "glucose_logs"
            ) { change in
                switch change {
                case .insert(let action):
                    print("inserted: ", action.record)
                    entries.append(action.record)
                case .update(let action):
                    print("Updated:", action.oldRecord, "->", action.record)
                case .delete(let action):
                    print("Deleted:", action.oldRecord)
                }
            }
        Task {
            try await channel.subscribeWithError()
        }
    }
    
    func addEntryToSupabase(entry: GlucoseEntry) async {
        let newEntry = GlucoseEntryDTO(
            row_id: entry.row_id,
            user_id: entry.user_id,
            time: entry.time,
            glucose_value: entry.glucoseValue,
            type: entry.glucoseType,
            notes: entry.notes
        )
        do {
            let response: GlucoseEntryDTO = try await client
                .from("glucose_logs")
                .insert(newEntry)
                .select()
                .single()
                .execute()
                .value
            print("adding entry: ", response)
        } catch {
            print("error adding entry: \(error)")
        }
    }
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
//    }
}
