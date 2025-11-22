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
    @Attribute(.unique) var row_id: UUID = UUID()
    var user_id: UUID
    var time: Date
    var glucoseValue: Int
    var glucoseType: GlucoseType
    var notes: String
    
    init(row_id: UUID, user_id: UUID, time: Date, glucoseValue: Int, glucoseType: GlucoseType, notes: String) {
        self.row_id = row_id
        self.user_id = user_id
        self.time = time
        self.glucoseValue = glucoseValue
        self.glucoseType = glucoseType
        self.notes = notes
    }
}

extension GlucoseEntry {
    convenience init(from dto: GlucoseEntryDTO) {
        self.init(
            row_id: dto.row_id,
            user_id: dto.user_id,
            time: dto.time,
            glucoseValue: dto.glucose_value,
            glucoseType: dto.type,
            notes: dto.notes ?? ""  // default value of "" if nil
        )
    }
}
