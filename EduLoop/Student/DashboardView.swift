import SwiftUI

struct DashboardView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top bar: Profile and Bell
                HStack(alignment: .center) {
                    // Profile
                    HStack(spacing: 12) {
                        Image("profile") // Replace with your asset name
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.systemGray5), lineWidth: 1))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hello, Zero")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Text("Building Knowledge,\nHand in Hand!")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer()
                    
                    // Notification bell
                    NavigationLink(destination: NotificationsView()) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 40, height: 40)
                            Image(systemName: "bell")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 32)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search by your location", text: $searchText)
                        .font(.subheadline)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Assignment Finder Card
                NavigationLink(destination: TermReportsView()) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Term Report")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Text("Find and check your term test marks.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 36))
                            .foregroundColor(.orange)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top, 18)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Quick Links
                VStack(alignment: .leading, spacing: 10) {
                    Text("Quick Links")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    
                    HStack(spacing: 18) {
                        NavigationLink(destination: HomeworkView()) {
                            QuickLinkCard(title: "Homework", icon: "book.fill", color: .yellow)
                        }
                        NavigationLink(destination: EventsView()) {
                            QuickLinkCard(title: "Events", icon: "calendar", color: .blue)
                        }
                        NavigationLink(destination: BringItemsView()) {
                            QuickLinkCard(title: "Items", icon: "bag.fill", color: .green)
                        }
                        NavigationLink(destination: NotesView()) {
                            QuickLinkCard(title: "Notes", icon: "note.text", color: .purple)
                        }

                        
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 18)
                
                // Upcoming Events
                VStack(alignment: .leading, spacing: 10) {
                    Text("Upcoming Events")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    
                    NavigationLink(destination: EventDetailView(event: Event(id: 1, title: "Science Day Competition", date: "May 21", time: "10:00 AM - 3:00 PM", location: "School Hall"))) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                VStack(alignment: .leading) {
                                    Text("Science Day Competition")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("May 21 • 10:00 AM - 3:00 PM")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.bottom, 4)
                            Text("School Hall")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.leading, 44)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(18)
                        .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: EventDetailView(event: Event(id: 1, title: "Parent-Teacher Meeting", date: "May 28", time: "10:00 AM - 3:00 PM", location: "School Hall"))) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                VStack(alignment: .leading) {
                                    Text("Parent-Teacher Meeting")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("May 21 • 10:00 AM - 3:00 PM")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.bottom, 4)
                            Text("School Hall")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.leading, 44)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(18)
                        .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top, 18)
                
                
                
                Spacer()
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}


struct QuickLinkCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(color)
                .cornerRadius(12)
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
        }
        .frame(width: 70)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct iew_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

