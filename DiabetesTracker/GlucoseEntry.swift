//
//  GlucoseEntry.swift
//  DiabetesTracker
//
//  Created by Megan on 8/28/25.
//

import Foundation
import SwiftData

enum GlucoseType: String, CaseIterable, Identifiable, Codable {
    case fasting, beforeMeal, afterMeal
    var id: Self {self}
}

@Model
class GlucoseEntry {
    var timestamp: Date
    var glucoseValue: Int
    var glucoseType: GlucoseType
    
    
    init(timestamp: Date, glucoseValue: Int, glucoseType: GlucoseType) {
        self.timestamp = timestamp
        self.glucoseValue = glucoseValue
        self.glucoseType = glucoseType
    }
}
