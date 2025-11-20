//
//  DashboardView.swift
//  DiabetesTracker
//
//  Created by Megan on 11/20/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Dashboard")
                .font(.largeTitle)
            
            Button("Sign Out") {
                Task {
                    await auth.signOut()
                }
            }
            .buttonStyle(.bordered)
        }
    }
}
