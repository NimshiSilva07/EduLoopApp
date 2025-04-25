import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var isLoggedIn = false
    @State private var isShowingSplash = true
    
    var body: some View {
        ZStack {
            if isShowingSplash {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                isShowingSplash = false
                            }
                        }
                    }
            } else if !hasSeenOnboarding {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            } else if !isLoggedIn {
                AuthenticationFlow(isLoggedIn: $isLoggedIn)
            } else {
                MainTabView()
            }
        }
    }
}

// Splash screen matching your design with yellow and blue circles
struct SplashScreen: View {
    var body: some View {
        ZStack {
            // Background
            Color.white.ignoresSafeArea()
            
            // Top-right yellow circle
            Circle()
                .fill(Color(hex: "#FFD580"))
                .frame(width: 200, height: 200)
                .offset(x: 100, y: -300)
            
            // Bottom-left blue circle
            Circle()
                .fill(Color(hex: "#ADD8E6"))
                .frame(width: 200, height: 200)
                .offset(x: -100, y: 300)
            
            // Logo and text
            VStack(spacing: 16) {
                Image("eduloop_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                
                Text("EduLoop")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("A seamless loop of communication for schools")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
    }
}

// Onboarding view with role selection
struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var navigateToLogin = false
    @State private var navigateToSignUp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.white.ignoresSafeArea()
                
                // Top-right yellow circle
                Circle()
                    .fill(Color(hex: "#FFD580"))
                    .frame(width: 200, height: 200)
                    .offset(x: 100, y: -300)
                
                // Bottom-left blue circle
                Circle()
                    .fill(Color(hex: "#ADD8E6"))
                    .frame(width: 200, height: 200)
                    .offset(x: -100, y: 300)
                
                VStack(spacing: 20) {
                    Image("eduloop_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                    
                    Text("EduLoop")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("A seamless loop of communication for schools")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Text("Welcome")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Welcome to EduLoop! Your all-in-one platform for staying updated with school events, homework, and important announcements.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        hasSeenOnboarding = true
                    }) {
                        Text("Student")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#1E3A8A"))
                            .cornerRadius(25)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        hasSeenOnboarding = true
                    }) {
                        Text("Teacher")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "#1E3A8A"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(hex: "#1E3A8A"), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            navigateToLogin = true
                            hasSeenOnboarding = true
                        }) {
                            Text("Sign In")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#1E3A8A"))
                                .cornerRadius(25)
                        }
                        
                        Button(action: {
                            navigateToSignUp = true
                            hasSeenOnboarding = true
                        }) {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "#1E3A8A"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(hex: "#1E3A8A"), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

// Authentication flow with login/register
struct AuthenticationFlow: View {
    @Binding var isLoggedIn: Bool
    @State private var showRegister = false
    
    var body: some View {
        NavigationView {
            if showRegister {
                RegisterView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}



// Color extension for hex colors
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
struct iew_pPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
