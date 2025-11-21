//
//  PreviewModels.swift
//  DiabetesTracker
//
//  Created by Megan on 11/20/25.
//

import SwiftData

@MainActor
struct PreviewContainer {
    static let shared: ModelContainer = {
        let schema = Schema([GlucoseEntry.self])

        let config = ModelConfiguration(isStoredInMemoryOnly: true)

        return try! ModelContainer(for: schema, configurations: [config])
    }()
}
