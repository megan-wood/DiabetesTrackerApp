//
//  GlucoseType.swift
//  DiabetesTracker
//
//  Created by Megan on 11/19/25.
//
import Foundation

enum GlucoseType: String, CaseIterable, Identifiable, Codable {
    case fasting, beforeMeal, afterMeal
    var id: Self { self }
}
