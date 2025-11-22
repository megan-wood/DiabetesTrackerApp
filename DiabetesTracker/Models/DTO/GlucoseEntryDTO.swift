//
//  GlucoseEntryDTO.swift
//  DiabetesTracker
//
//  Created by Megan on 11/19/25.
//

import Foundation

struct GlucoseEntryDTO: Codable, Identifiable {
    let row_id: UUID
    let user_id: UUID
    let time: Date
    let glucose_value: Int
    let type: GlucoseType
    let notes: String?  // notes can be null
    
    // map row_id to id for SwiftUI
    var id: UUID { row_id }
}
