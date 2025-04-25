import SwiftUI

struct BringItemsView: View {
    @State private var bringItems: [BringItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading) {
                HStack {
                   
                    
                    Spacer()
                    
                    Text("Items to Bring")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        // Search action
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.green.opacity(0.8))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Illustration
                HStack {
                    Spacer()
                    Image("bring_items_illustration") // You'll need to add this image to your assets
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                    Spacer()
                }
                .padding(.bottom, 10)
            }
            .background(
                Image("bring1")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .opacity(0.5)
            )
            .background(Color.black)
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
            
            // Title
            HStack {
                Text("Items To Bring")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            
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
            } else {
                // Items List
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(bringItems) { item in
                            BringItemRow(item: item)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
            

        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            loadBringItemsData()
        }
    }
    
    private func loadBringItemsData() {
        isLoading = true
        
        Task {
            do {
                let data: [BringItem] = try await NetworkManager.shared.fetchData(endpoint: "bring-items")
                DispatchQueue.main.async {
                    self.bringItems = data
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load items: \(error.localizedDescription)"
                    self.isLoading = false
                    
                    // Load static data as fallback
                    self.loadStaticData()
                }
            }
        }
    }
    
    private func loadStaticData() {
        bringItems = [
            BringItem(id: 1, title: "Get colors of Leaves (for Exam)", dueDate: "Today", status: "Pending"),
            BringItem(id: 2, title: "The Water Cycle (A Model)", dueDate: "Tomorrow", status: "Pending"),
            BringItem(id: 3, title: "The Human Body (A Model)", dueDate: "Next Week", status: "Pending")
        ]
    }
}

struct BringItemRow: View {
    let item: BringItem
    @State private var isPreviewShown = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                // Status indicator
                Circle()
                    .fill(statusColor)
                    .frame(width: 10, height: 10)
                    .padding(.top, 5)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(item.dueDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 5)
                
                Spacer()
                
                Button(action: {
                    isPreviewShown.toggle()
                }) {
                    Image(systemName: "eye")
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            // Preview section
            if isPreviewShown {
                ItemPreviewView(item: item)
                    .padding(.top, 2)
            }
        }
    }
    
    var statusColor: Color {
        switch item.status.lowercased() {
        case "completed":
            return .green
        case "pending":
            return .yellow
        case "overdue":
            return .red
        default:
            return .gray
        }
    }
}

struct ItemPreviewView: View {
    let item: BringItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Preview")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(alignment: .top, spacing: 15) {
                // Item image placeholder
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.title)
                        .font(.headline)
                    
                    Text("Description: This item is required for the upcoming class activity. Please ensure it is brought on time.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                    
                    Text("Due: \(item.dueDate)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    // Mark as done action
                }) {
                    Text("Mark as Done")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .cornerRadius(20)
                }
                
                Spacer()
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Helper extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}




// Preview
struct BringItemsView_Previews: PreviewProvider {
    static var previews: some View {
        BringItemsView()
    }
}
