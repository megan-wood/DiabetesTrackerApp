//
//  ContentView.swift
//  DiabetesTracker
//
//  Created by Megan on 8/28/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [GlucoseEntry]
    
    @State private var timestamp: Date = Date.now
    @State private var selectedType: GlucoseType = .fasting
    @State private var enteredGlucose: String = ""
//    @State private var enteredGlucose: Int? = nil
    @State private var isShowingForm = false

    var body: some View {
        NavigationSplitView {
            
            List {
                ForEach(entries) { entry in
                    NavigationLink {
                        Text("Entry at \(entry.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard)) had glucose value \(entry.glucoseValue)")
                            .padding()
                    } label: {
                        Text("\(entry.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard)) had value \(entry.glucoseValue)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        isShowingForm.toggle()
                        timestamp = Date.now

                    }) {
//                    Button(action: add Entry) {
                        Label("Add Entry", systemImage: "plus")

                    }
                    .sheet(isPresented: $isShowingForm, onDismiss: doDismiss) {
                        NavigationStack {
                            VStack {
                                Form {
                                    Section() {
                                        DatePicker(
                                            "Time and Date: ",
                                            selection: $timestamp,
                                            displayedComponents: [.date, .hourAndMinute]
                                        )
                                        HStack {
                                            Text("Glucose value: ")
                                            TextField("ex: 100",text: $enteredGlucose)
                                                .keyboardType(.numberPad)
                                                .multilineTextAlignment(.trailing)
//                                            TextField("Glucose Value: ", value: $enteredGlucose, format: .number)
//                                                .keyboardType(.numberPad)
                                        }
                                        Picker("Glucose Type", selection: $selectedType) {
                                            Text("Fasting").tag(GlucoseType.fasting)
                                            Text("Before Meal").tag(GlucoseType.beforeMeal)
                                            Text("After Meal").tag(GlucoseType.afterMeal)
                                        }
                                    }
                                }
//                                HStack {
//                                    Button("Cancel", action: {
//                                        isShowingForm.toggle()
//                                        doDismiss()
//                                    })
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color.red.opacity(0.2))
//                                    .foregroundColor(.red)
//                                    .cornerRadius(10)
//                                    
//                                    
//                                    Spacer()
//                                    
//                                    Button("Save") {
//                                        doDismiss()
//                                    }
//                                    .bold()
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .foregroundColor(.white)
//                                    .cornerRadius(10)
//                                    .buttonStyle(.automatic)
//                                }
//                                .padding([.horizontal, .bottom])
                            }
                            .navigationTitle("Add Glucose Entry")
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    // make it so you can only save once you have input info
                                    Button("Save") {
                                        if let glucoseInt = Int(enteredGlucose) {
                                            let newEntry = GlucoseEntry(timestamp: timestamp, glucoseValue: glucoseInt, glucoseType: selectedType)
                                            modelContext.insert(newEntry)

                                        }
                                        isShowingForm.toggle()
                                        doDismiss()
                                    }
                                    .bold()
                                }
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancel", action: {
                                        isShowingForm.toggle()
                                        doDismiss()
                                    })
                                    .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(.bar)
                            
                        }
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        
    }
    
    private func doDismiss() {
        timestamp = Date.now
        selectedType = .fasting
        enteredGlucose = ""
    }

//    private func addEntry() {
//        withAnimation {
//            let newEntry = GlucoseEntry(timestamp: Date(), glucoseValue: enteredGlucose, glucoseType: selectedType)
//            modelContext.insert(newEntry)
//        }
//    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(entries[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: GlucoseEntry.self, inMemory: true)
}
