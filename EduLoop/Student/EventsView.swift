import SwiftUI

struct EventsView: View {
    @State private var events: [EventDetail] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedFilter = 0 // 0 = Upcoming, 1 = Ongoing, 2 = Past
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading) {
                HStack {
                    Text("Events")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        // Clear all action
                    }) {
                        Text("Clear all")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 15)
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // Filter tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        FilterTabButton(title: "Upcoming", isSelected: selectedFilter == 0) {
                            selectedFilter = 0
                            loadEventsData()
                        }
                        
                        FilterTabButton(title: "Ongoing", isSelected: selectedFilter == 1) {
                            selectedFilter = 1
                            loadEventsData()
                        }
                        
                        FilterTabButton(title: "Past", isSelected: selectedFilter == 2) {
                            selectedFilter = 2
                            loadEventsData()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if let errorMessage = errorMessage {
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                Spacer()
            } else if events.isEmpty {
                Spacer()
                Text("No events found")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                // Events list
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(events) { event in
                            NavigationLink(destination: EventDetailView(event: Event(id: event.id, title: event.title, date: event.date, time: event.time, location: event.location, description: event.description, image: event.image))) {
                                EventCardView(event: event)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
            
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            loadEventsData()
        }
    }
    
    private func loadEventsData() {
        isLoading = true
        
        let endpoint: String
        switch selectedFilter {
        case 0:
            endpoint = "events/upcoming"
        case 1:
            endpoint = "events/ongoing"
        case 2:
            endpoint = "events/past"
        default:
            endpoint = "events/upcoming"
        }
        
        Task {
            do {
                let data: [EventDetail] = try await NetworkManager.shared.fetchData(endpoint: endpoint)
                DispatchQueue.main.async {
                    self.events = data
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load events: \(error.localizedDescription)"
                    self.isLoading = false
                    
                    // Load static data as fallback
                    self.loadStaticData()
                }
            }
        }
    }
    
    private func loadStaticData() {
        switch selectedFilter {
        case 0: // Upcoming
            events = [
                EventDetail(id: 1, title: "Science Fair Competition", date: "May 10, 2025", time: "10:00 AM - 3:00 PM", location: "School Hall", description: "Join us for an exciting science fair where students will showcase their innovative projects.", image: "science_fair"),
                EventDetail(id: 2, title: "Chess Day Competition", date: "May 15, 2025", time: "9:00 AM - 5:00 PM", location: "Activity Room", description: "Annual chess tournament for all skill levels.", image: "chess_competition")
            ]
        case 1: // Ongoing
            events = [
                EventDetail(id: 3, title: "Spring Art Exhibition", date: "April 20-30, 2025", time: "All day", location: "Art Gallery", description: "A showcase of student artwork created during the spring semester.", image: "art_exhibition")
            ]
        case 2: // Past
            events = [
                EventDetail(id: 4, title: "Math Olympiad", date: "March 15, 2025", time: "9:00 AM - 1:00 PM", location: "Main Auditorium", description: "Annual mathematics competition for talented students.", image: "math_olympiad"),
                EventDetail(id: 5, title: "Sports Day", date: "February 28, 2025", time: "8:00 AM - 4:00 PM", location: "School Grounds", description: "Annual sports competition featuring various athletic events.", image: "sports_day")
            ]
        default:
            events = []
        }
    }
}

struct FilterTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .cornerRadius(20)
        }
    }
}

struct EventCardView: View {
    let event: EventDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Event image
            ZStack(alignment: .bottomLeading) {
                // Image placeholder
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(height: 180)
                    .overlay(
                        Group {
                            if event.title.contains("Science Fair") {
                                Image("science_fair_image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 180)
                                    .clipped()
                            } else if event.title.contains("Chess") {
                                Image("chess_competition_image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 180)
                                    .clipped()
                            } else {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                            }
                        }
                    )
                
                // Event title overlay
                VStack(alignment: .leading, spacing: 5) {
                    Text(event.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.white)
                        Text(event.location)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.white)
                        Text("\(event.date), \(event.time)")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
            }
            
            // Event details
            VStack(alignment: .leading, spacing: 8) {
                Text(event.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Spacer()
                    
                    Text("View details")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
            .padding(12)
            .background(Color.white)
        }
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct EventDetailView: View {
    let event: Event
    @StateObject private var eventKitManager = EventKitManager()
    @State private var showingCalendarAlert = false
    @State private var calendarSuccess = false
    @State private var calendarMessage = ""
    
    // Function to parse date and time strings
    private func getEventDateTime() -> (start: Date, end: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        // Default to current date if parsing fails
        let eventDate = dateFormatter.date(from: event.date) ?? Date()
        
        // Parse time range like "10:00 AM - 3:00 PM"
        let timeParts = event.time.components(separatedBy: " - ")
        let startTimeString = timeParts.first ?? "9:00 AM"
        let endTimeString = timeParts.last ?? "10:00 AM"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        // Create start and end date components
        var startComponents = Calendar.current.dateComponents([.year, .month, .day], from: eventDate)
        var endComponents = Calendar.current.dateComponents([.year, .month, .day], from: eventDate)
        
        if let startTime = timeFormatter.date(from: startTimeString) {
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: startTime)
            startComponents.hour = timeComponents.hour
            startComponents.minute = timeComponents.minute
        }
        
        if let endTime = timeFormatter.date(from: endTimeString) {
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: endTime)
            endComponents.hour = timeComponents.hour
            endComponents.minute = timeComponents.minute
        }
        
        let startDate = Calendar.current.date(from: startComponents) ?? Date()
        let endDate = Calendar.current.date(from: endComponents) ?? Date().addingTimeInterval(3600)
        
        return (startDate, endDate)
    }
    
    private func addToCalendar() {
        let dateTime = getEventDateTime()
        let success = eventKitManager.addEventToCalendar(
            title: event.title,
            startDate: dateTime.start,
            endDate: dateTime.end,
            location: event.location,
            notes: event.description ?? "No description available"
        )
        
        calendarSuccess = success
        calendarMessage = success ? "Event added to your calendar successfully!" : "Failed to add event to calendar. Please check calendar permissions in Settings."
        showingCalendarAlert = true
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Event image
                ZStack(alignment: .bottomLeading) {
                    // Image placeholder
                    Rectangle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(height: 250)
                        .overlay(
                            Group {
                                if event.title.contains("Science Fair") {
                                    Image("science_fair_image")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 250)
                                        .clipped()
                                } else if event.title.contains("Chess") {
                                    Image("chess_competition_image")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 250)
                                        .clipped()
                                } else {
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.system(size: 60))
                                        .foregroundColor(.blue)
                                }
                            }
                        )
                    
                    // Event title overlay
                    VStack(alignment: .leading, spacing: 5) {
                        Text(event.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0)]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    // Event details
                    Group {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .frame(width: 25)
                            Text(event.date)
                                .foregroundColor(.primary)
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                                .frame(width: 25)
                            Text(event.time)
                                .foregroundColor(.primary)
                        }
                        
                        HStack {
                            Image(systemName: "location")
                                .foregroundColor(.blue)
                                .frame(width: 25)
                            Text(event.location)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    // Description
                    Text("About")
                        .font(.headline)
                    
                    if let description = event.description {
                        Text(description)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    // Register button
                    Button(action: {
                        addToCalendar()
                    }) {
                        HStack {
                            Text("Register")
                                .font(.headline)
                            Image(systemName: "calendar.badge.plus")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("", displayMode: .inline)
        .alert(isPresented: $showingCalendarAlert) {
            Alert(
                title: Text(calendarSuccess ? "Success" : "Error"),
                message: Text(calendarMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            eventKitManager.checkCalendarAuthorization()
        }
    }
}


// Preview
struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
