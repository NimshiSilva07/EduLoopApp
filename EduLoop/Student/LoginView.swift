import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    @State private var showForgotPassword = false
    @Binding var isLoggedIn: Bool
    
    // Static user for demo
    let staticUser = ("student", "password123")
    
    var body: some View {
        ZStack {
            // Background with corner decorations
            Color.white.ignoresSafeArea()
            
            // Top-right yellow circle
            Circle()
                .fill(Color(hex: "#FFD580"))
                .frame(width: 200, height: 200)
                .offset(x: 100, y: -350)
            
            VStack(spacing: 20) {
                // Back button and Register link
                HStack {
                    Button(action: {
                        // Back action
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "#1E3A8A"))
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                            .foregroundColor(Color(hex: "#1E3A8A"))
                    }
                }
                .padding(.horizontal)
                
                // Sign In title and description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sign In")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Sign in to EduLoop and stay connected with school updates, homework, and important announcements!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                
                // Login form
                VStack(spacing: 16) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // Forgot Password
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            showForgotPassword = true
                        }
                        .font(.footnote)
                        .foregroundColor(Color(hex: "#1E3A8A"))
                    }
                    .padding(.horizontal)
                    
                    // Sign In Button
                    Button(action: {
                        if username == "Nimshi" && password == "nim123" {
                            isLoggedIn = true
                        } else {
                            showError = true
                        }
                    }) {
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#1E3A8A"))
                            .cornerRadius(25)
                    }
                    .padding(.horizontal)
                    .disabled(username.isEmpty || password.isEmpty)
                    
                    if showError {
                        Text("Invalid credentials")
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
                
                Spacer()
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct iew_Previews1: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
