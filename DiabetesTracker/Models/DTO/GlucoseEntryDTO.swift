//
//  GlucoseEntryDTO.swift
//  DiabetesTracker
//
//  Created by Megan on 11/19/25.
//

struct GlucoseEntryDTO: Codable, Identifiable {
    let id: Int
    let time: Date
    let glucoseValue: Int
    let glucoseType: GlucoseType
    let notes: String
}
