import SwiftUI

struct TermReportsView: View {
    @State private var reportData: ReportData?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedExam = 0 // 0 = Term Exam, 1 = Monthly Exam
    
    var body: some View {
        VStack {
            // Header
            Text("Report")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            // Filter
            Picker("Exam Type", selection: $selectedExam) {
                Text("Term Exam Results").tag(0)
                Text("Monthly Exam Results").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onChange(of: selectedExam) { newValue in
                loadReportData()
            }
            
            // Search
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Search the exam...")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if let data = reportData {
                // Table header
                HStack {
                    Text("Subjects")
                        .font(.headline)
                        .frame(width: 100, alignment: .leading)
                    
                    Spacer()
                    
                    Text("Marks")
                        .font(.headline)
                        .frame(width: 80, alignment: .center)
                    
                    Spacer()
                    
                    Text("Achievement")
                        .font(.headline)
                        .frame(width: 100, alignment: .trailing)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                
                // Table rows
                List {
                    ForEach(data.subjects) { subject in
                        SubjectRowView(subject: subject)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationBarTitle(selectedExam == 0 ? "Term Reports" : "Monthly Exams", displayMode: .inline)
        .onAppear {
            loadReportData()
        }
    }
    
    private func loadReportData() {
        isLoading = true
        
        let endpoint = selectedExam == 0 ? "term-reports" : "monthly-exams"
        
        Task {
            do {
                let data: ReportData = try await NetworkManager.shared.fetchData(endpoint: endpoint)
                DispatchQueue.main.async {
                    self.reportData = data
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load reports: \(error.localizedDescription)"
                    self.isLoading = false
                    
                    // Load static data as fallback
                    self.loadStaticData()
                }
            }
        }
    }
    
    private func loadStaticData() {
        let subjects = [
            Subject(name: "Maths", marks: "95%", achievement: "Excellent"),
            Subject(name: "Science", marks: "87%", achievement: "Good"),
            Subject(name: "English", marks: "100%", achievement: "Outstanding"),
            Subject(name: "Health", marks: "92%", achievement: "Excellent"),
            Subject(name: "Religion", marks: "92%", achievement: "Excellent"),
            Subject(name: "Art", marks: "100%", achievement: "Excellent"),
            Subject(name: "Drawing", marks: "85%", achievement: "Excellent"),
            Subject(name: "PE", marks: "96%", achievement: "Excellent")
        ]
        
        self.reportData = ReportData(subjects: subjects)
    }
}

struct SubjectRowView: View {
    let subject: Subject
    
    var body: some View {
        HStack {
            Text(subject.name)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Text(subject.marks)
                .frame(width: 80, alignment: .center)
            
            Spacer()
            
            Text(subject.achievement)
                .foregroundColor(achievementColor)
                .frame(width: 100, alignment: .trailing)
        }
        .padding(.vertical, 8)
        .background(rowBackgroundColor)
    }
    
    var achievementColor: Color {
        switch subject.achievement.lowercased() {
        case "excellent":
            return .green
        case "good":
            return .blue
        case "outstanding":
            return .purple
        default:
            return .primary
        }
    }
    
    var rowBackgroundColor: Color {
        switch subject.name.lowercased() {
        case "maths":
            return Color.blue.opacity(0.1)
        case "science":
            return Color.red.opacity(0.1)
        case "english":
            return Color.green.opacity(0.1)
        case "health":
            return Color.yellow.opacity(0.1)
        case "religion":
            return Color.orange.opacity(0.1)
        case "art":
            return Color.purple.opacity(0.1)
        case "drawing":
            return Color.pink.opacity(0.1)
        case "pe":
            return Color.gray.opacity(0.1)
        default:
            return Color(.systemBackground)
        }
    }
}

struct previews1: PreviewProvider {
    static var previews: some View {
        TermReportsView()
    }
}
