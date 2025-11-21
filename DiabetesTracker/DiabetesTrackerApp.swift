//
//  DiabetesTrackerApp.swift
//  DiabetesTracker
//
//  Created by Megan on 8/28/25.
//

import SwiftUI
import SwiftData

@main
struct DiabetesTrackerApp: App {
    
    @StateObject var auth = AuthViewModel() // creates auth controller
    @StateObject var data = DataViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GlucoseEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(auth)  // puts into SwiftUI environment so all view can access it
                .environmentObject(data)
//                .task {
//                    await auth.signOut()
//                }
        }
        .modelContainer(sharedModelContainer)
    }
}
