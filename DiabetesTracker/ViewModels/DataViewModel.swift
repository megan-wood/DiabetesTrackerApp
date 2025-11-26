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
//    private var listener: PostgresChangeHandler?
    
    private let client = SupabaseService.shared.client
    
    init() {
        Task {
            let session = try? await client.auth.session
                   print("SESSION AT INIT:", session ?? "nil")
            await load()
            await subscribeToRealtime()

        }
//        subscribeToRealtime()
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
    
    func subscribeToRealtime() async {
        self.channel = client.channel("glucose-realtime")
        
        let changes =  channel?.postgresChange(
            AnyAction.self,
//            GlucoseEntryDTO.self,
            schema: "public",
            table: "glucose_logs"
            )
        
        guard let stream = changes else {
            print("❌ Failed to get Realtime stream. Check channel initialization or connection state.")
            return
        }
        
        do {
            try await channel?.subscribeWithError()
            print("subscribed to changes from database")
            
            for await change in stream {
                switch change {
                case .insert(let action):
//                    print("inserted: ", action.record)
                    print("inserted")
                    do {
//                        let data = try JSONSerialization.data(withJSONObject: action.record)
//                        let entryDTO = try change.decodeRecord(as: GlucoseEntryDTO.self)
//                        let entryDTO = try JSONDecoder().decode(GlucoseEntryDTO.self, from: data
                        let data = try JSONEncoder().encode(action.record)
                        let dto = try JSONDecoder().decode(GlucoseEntryDTO.self, from: data)
                        DispatchQueue.main.async {
                            let entry = GlucoseEntry(from: dto)
                            self.entries.append(entry)
                        }
                    } catch {
                        print("Failed to decode realtime DTO:", error)
                    }
                case .update(let action):
                    print("Updated:", action.oldRecord, "->", action.record)
                case .delete(let action):
                    print("Deleted:", action.oldRecord)
                }
            }
        } catch {
            print("❌ Failed to subscribe or error in stream: \(error)")
        }
//        { change in
//                print("change")
//                switch change {
//                case .insert(let action):
//                    print("inserted: ", action.record)
//                    do {
//                        let data = try JSONSerialization.data(withJSONObject: action.record)
//                        let entryDTO = try JSONDecoder().decode(GlucoseEntryDTO.self, from: data)
//                        DispatchQueue.main.async {
//                            let entry = GlucoseEntry(from: entryDTO)
//                            self.entries.append(entry)
//                        }
//
//                    } catch {
//                        print("Failed to decode realtime DTO:", error)
//                    }
//                case .update(let action):
//                    print("Updated:", action.oldRecord, "->", action.record)
//                case .delete(let action):
//                    print("Deleted:", action.oldRecord)
//                }
//            }
//        Task {
//            do {
//                try await self.channel?.subscribeWithError()
//            } catch {
//                print("realtime subscription failed:", error)
//            }
//        }
    }
    
    func addEntryToSupabase(entry: GlucoseEntry) async {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let dateString = dateFormatter.string(from: entry.time)
        
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
