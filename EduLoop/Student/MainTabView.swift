import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            HomeworkView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Homework")
                }
            
            BringItemsView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Items")
                }
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View - Coming Soon")
            .font(.title)
    }
}
