import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ログイン / 新規登録")
                .font(.largeTitle)
                .bold()
            
            TextField("メールアドレス", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("パスワード", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack(spacing: 20) {
                Button("ログイン") {
                    login()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                Button("新規登録") {
                    register()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
            }
            
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(message.contains("成功") ? .green : .red)
            }
        }
        .padding()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                message = "ログインエラー: \(error.localizedDescription)"
            } else if let user = result?.user {
                if user.isEmailVerified {
                    message = "ログイン成功！"
                } else {
                    message = "メールアドレスが未確認です。メールを確認してください。"
                    user.sendEmailVerification { error in
                        if let error = error {
                            print("確認メールの再送信に失敗: \(error.localizedDescription)")
                        } else {
                            print("確認メールを再送信しました。")
                        }
                    }
                    try? Auth.auth().signOut()
                }
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                message = "登録エラー: \(error.localizedDescription)"
            } else if let user = result?.user {
                user.sendEmailVerification { error in
                    if let error = error {
                        message = "確認メール送信エラー: \(error.localizedDescription)"
                    } else {
                        message = "登録成功！確認メールを送信しました。メールを確認してください。"
                    }
                }
            }
        }
    }
}
