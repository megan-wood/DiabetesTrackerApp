//
//  GlucoseEntry.swift
//  DiabetesTracker
//
//  Created by Megan on 11/19/25.
//

import Foundation
import SwiftData

@Model
class GlucoseEntry {
    @Attribute(.unique) var id: UUID = UUID()
    var time: Date
    var glucoseValue: Int
    var glucoseType: GlucoseType
    var notes: String
    
    init(id: UUID, time: Date, glucoseValue: Int, glucoseType: GlucoseType, notes: String) {
        self.id = id
        self.time = time
        self.glucoseValue = glucoseValue
        self.glucoseType = glucoseType
        self.notes = notes
    }
}

extension GlucoseEntry {
    convenience init(from dto: GlucoseEntryDTO) {
        self.init(
            id: dto.id,
            time: dto.time,
            glucoseValue: dto.glucoseValue,
            glucoseType: dto.glucoseType,
            notes: dto.notes
        )
    }
}
