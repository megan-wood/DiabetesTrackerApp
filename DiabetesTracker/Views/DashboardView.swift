//
//  DashboardView.swift
//  DiabetesTracker
//
//  Created by Megan on 11/20/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var data: DataViewModel
    @Environment(\.modelContext) private var modelContext
    
//    @State private var id: Int = 0
//    @State private var time: Date = Date.now
//    @State private var selectedType: GlucoseType = .fasting
//    @State private var enteredGlucose: String = ""
//    @State private var enteredNotes: String = ""
    @State private var isShowingForm = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Dashboard")
                .font(.largeTitle)
            NavigationSplitView {
                List {
//                    print("entries: ", data.entries)
                    if data.entries.isEmpty {
                            Text("No entries yet!")
                                .foregroundColor(.gray)
                    } else {
                        ForEach(data.entries) { entry in
                            NavigationLink {
                                Text("Entry at \(entry.time.formatted(date: .numeric, time: .standard)) had glucose value \(entry.glucoseValue)")
                                    .padding()
                            }  label: {
                                Text("\(entry.time.formatted(date: .numeric, time: .standard)) • \(entry.glucoseValue)")
                                
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button {
                            isShowingForm = true
                        } label: {
                            Label("Add Entry", systemImage: "plus")
                        }
                    }
                }
            } detail: {
                Text("Select an item")
            }
            
            Button("Sign Out") {
                Task {
                    await auth.signOut()
                }
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $isShowingForm) {
            AddEntryForm { entry in
                modelContext.insert(entry)
            }
        }
    }
}
