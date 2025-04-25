import SwiftUI

struct NotificationsView: View {
    @State private var notifications: [NotificationItem] = []
    @State private var filteredNotifications: [NotificationItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedFilter = 0 // 0 = All, 1 = Unread
    
    var body: some View {
        VStack {
            // Header
            Text("Notifications")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            // Filter
            Picker("Filter", selection: $selectedFilter) {
                Text("All Notifications").tag(0)
                Text("Unread").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onChange(of: selectedFilter) { newValue in
                filterNotifications()
            }
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List {
                    ForEach(filteredNotifications) { notification in
                        NotificationItemView(notification: notification)
                            .onTapGesture {
                                markAsRead(notification: notification)
                            }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationBarTitle("Notifications", displayMode: .inline)
        .onAppear {
            loadNotificationsData()
        }
        .tabItem {
            Image(systemName: "bell")
            Text("Notifications")
        }
    }
    
    private func loadNotificationsData() {
        isLoading = true
        
        Task {
            do {
                let data: [NotificationItem] = try await NetworkManager.shared.fetchData(endpoint: "notifications")
                DispatchQueue.main.async {
                    self.notifications = data
                    self.filterNotifications()
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load notifications: \(error.localizedDescription)"
                    self.isLoading = false
                    
                    // Load static data as fallback
                    self.loadStaticData()
                }
            }
        }
    }
    
    private func loadStaticData() {
        notifications = [
            NotificationItem(id: 1, title: "Ms. Ann Davis", message: "Today's homework has been uploaded. Please check your assignments.", time: "Today", isRead: false, avatar: "teacher1"),
            NotificationItem(id: 2, title: "Mr. John Smith", message: "Tomorrow's science trip will be held for Math and English classes.", time: "Today", isRead: false, avatar: "teacher2"),
            NotificationItem(id: 3, title: "Ms. Ann Davis", message: "Reminder: Make sure you bring all of your science materials for tomorrow's lab session.", time: "Yesterday", isRead: true, avatar: "teacher1"),
            NotificationItem(id: 4, title: "Mr. Robert Johnson", message: "Bring lab coat, face mask, and safety goggles for tomorrow's chemistry experiment.", time: "Yesterday", isRead: true, avatar: "teacher3")
        ]
        filterNotifications()
    }
    
    private func filterNotifications() {
        if selectedFilter == 1 {
            // Show only unread
            filteredNotifications = notifications.filter { !$0.isRead }
        } else {
            // Show all
            filteredNotifications = notifications
        }
    }
    
    private func markAsRead(notification: NotificationItem) {
        guard !notification.isRead else { return }
        
        Task {
            do {
                let success = try await NetworkManager.shared.markNotificationAsRead(id: notification.id)
                if success {
                    DispatchQueue.main.async {
                        if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                            self.notifications[index].isRead = true
                            self.filterNotifications()
                        }
                    }
                }
            } catch {
                print("Failed to mark notification as read: \(error.localizedDescription)")
                
                // Update locally anyway for better UX
                DispatchQueue.main.async {
                    if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                        self.notifications[index].isRead = true
                        self.filterNotifications()
                    }
                }
            }
        }
    }
}

struct NotificationItemView: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Avatar
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(notification.title)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(notification.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            if !notification.isRead {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
