//
//  LoginView.swift
//  DiabetesTracker
//
//  Created by Megan on 11/20/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button("Sign In") {
                Task {
                    await auth.signIn(email: email, password: password)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
