import SwiftUI

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSuccess = false
    @Environment(\.presentationMode) var presentationMode
    
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
                // Back button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "#1E3A8A"))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // Sign Up title and description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sign Up")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Create your EduLoop account and stay informed about school events, homework, and important updates!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                
                // Registration form
                VStack(spacing: 16) {
                    TextField("First Name", text: $firstName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    TextField("Last Name", text: $lastName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    TextField("Index", text: $lastName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    SecureField("Re-enter Password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // Sign Up Button
                    Button(action: {
                        if !firstName.isEmpty && !lastName.isEmpty && password == confirmPassword {
                            showSuccess = true
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
                    .disabled(firstName.isEmpty || lastName.isEmpty || password.isEmpty || confirmPassword.isEmpty)
                    
                    if showSuccess {
                        Text("Registration Successful! Please Sign In.")
                            .foregroundColor(.green)
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
