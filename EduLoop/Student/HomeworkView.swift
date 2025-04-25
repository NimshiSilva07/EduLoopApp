import SwiftUI

struct HomeworkView: View {
    @State private var homeworkItems: [HomeworkItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Homework")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 24)

            if isLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(1.3)
                    .padding()
                Spacer()
            } else if let errorMessage = errorMessage {
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(homeworkItems.indices, id: \.self) { index in
                            HomeworkItemView(item: homeworkItems[index]) {
                                // Button action to mark as completed
                                homeworkItems[index].status = "Completed"
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadHomeworkData()
        }
    }

    private func loadHomeworkData() {
        isLoading = true

        Task {
            do {
                let data: [HomeworkItem] = try await NetworkManager.shared.fetchData(endpoint: "homework")
                DispatchQueue.main.async {
                    self.homeworkItems = data
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load homework: \(error.localizedDescription)"
                    self.isLoading = false
                    self.loadStaticData()
                }
            }
        }
    }

    private func loadStaticData() {
        homeworkItems = [
            HomeworkItem(id: 1, title: "Science Book: Complete exercises on page 45 to 49.", dueDate: "Today, 12:00 PM", status: "Pending", type: "Assignment", description: "Complete exercises on page 45 to 49."),
            HomeworkItem(id: 2, title: "Maths Workbook: Solve all problems", dueDate: "Today, 3:30 PM", status: "Pending", type: "Project", description: "Finish your science group project summary."),
            HomeworkItem(id: 3, title: "English Essay", dueDate: "Today, 5:00 PM", status: "Completed", type: "Essay", description: "Write an essay about your weekend.")
        ]
    }
}

struct HomeworkItemView: View {
    var item: HomeworkItem
    var onComplete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    if let type = item.type {
                        Text(type)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }

                Spacer()
            }

            if let description = item.description {
                Text(description)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }

            HStack {
                Label(item.dueDate, systemImage: "clock")
                    .font(.footnote)
                    .foregroundColor(.gray)

                Spacer()

                if item.status.lowercased() != "completed" {
                    Button(action: onComplete) {
                        Text("Mark as Done")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Text("✓ Completed")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    var statusColor: Color {
        switch item.status.lowercased() {
        case "completed":
            return .green
        case "pending":
            return .orange
        case "overdue":
            return .red
        default:
            return .gray
        }
    }
}
