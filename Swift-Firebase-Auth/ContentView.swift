//
//  ContentView.swift
//  Swift-Firebase-Auth
//
//  Created by kmjak on 2025/06/08.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ログイン")
                .font(.largeTitle)
                .bold()
            
            TextField("メールアドレス", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("パスワード", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("ログイン") {
                login()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                message = "エラー: \(error.localizedDescription)"
            } else {
                message = "ログイン成功！"
            }
        }
    }
}
