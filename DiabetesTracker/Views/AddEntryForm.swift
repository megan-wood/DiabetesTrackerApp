//
//  AddEntryForm.swift
//  DiabetesTracker
//
//  Created by Megan on 11/21/25.
//

import SwiftUI
import Foundation

struct AddEntryForm: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthViewModel
    
    @State private var time: Date = Date.now
    @State private var glucose: String = ""
    @State private var type: GlucoseType = .fasting
    @State private var notes: String = ""
    
    var onSave: (GlucoseEntry) -> Void
    
    var isValid: Bool {
        Int(glucose) != nil && !glucose.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Glucose Data") {
                    DatePicker(
                        "Time",
                        selection: $time,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    
                    HStack {
                        Text("Glucose Value")
                        TextField("ex: 100", text: $glucose)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("Type", selection: $type) {
                        Text("Fasting").tag(GlucoseType.fasting)
                        Text("Before Meal").tag(GlucoseType.beforeMeal)
                        Text("After Meal").tag(GlucoseType.afterMeal)
                    }
                    
                    TextEditor(text: $notes)
                        .frame(height: 80)
                }
            }
            .navigationTitle("Add Glucose Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let userId = auth.curUser?.id else {
                            print("Error: no logged in user to add entry")
                            return
                        }
                        
                        let isoFormatter = ISO8601DateFormatter()
                        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                        let utcString = isoFormatter.string(from: time)
                        if let value = Int(glucose) {
                            let entry = GlucoseEntry(
                                row_id: UUID(),
                                user_id: userId,
                                time: utcString,
                                glucoseValue: value,
                                glucoseType: type,
                                notes: notes
                            )
                            onSave(entry)
                            dismiss()
                        }
                    }
                    .disabled(!isValid)
                    .bold()
                }
            }
        }
    }
}
