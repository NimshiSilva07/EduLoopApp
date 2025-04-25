import SwiftUI

struct NotesView: View {
    // Sample note data for parents
    @State private var notes: [ParentNote] = [
        ParentNote(id: 1, title: "Reminder: Evening Class", message: "There will be a special Math class tomorrow evening at 5:00 PM."),
        ParentNote(id: 2, title: "Share Math Notes", message: "Please ensure your child brings a copy of their math notes to school tomorrow."),
        ParentNote(id: 3, title: "No School Friday", message: "School will be closed this Friday due to maintenance work."),
        ParentNote(id: 4, title: "PTM Scheduled", message: "Parent-Teacher Meeting will be held on Monday at 10:00 AM."),
        ParentNote(id: 5, title: "Healthy Snack Day", message: "Please pack a healthy snack for your child this Wednesday.")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(notes) { note in
                        ParentNoteCard(note: note)
                    }
                }
                .padding()
            }
            .navigationTitle("Important Notes")
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

struct ParentNote: Identifiable {
    let id: Int
    let title: String
    let message: String
}

struct ParentNoteCard: View {
    let note: ParentNote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "note.text")
                    .font(.title2)
                    .foregroundColor(.purple)
                    .padding(8)
                    .background(Color.purple.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(note.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(note.message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
