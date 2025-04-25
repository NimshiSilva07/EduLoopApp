import SwiftUI

// Dashboard Models
struct QuickLink: Identifiable, Decodable {
    let id: Int
    let title: String
    let icon: String
    let color: String
}

struct Event: Identifiable, Decodable {
    let id: Int
    let title: String
    let date: String
    let time: String
    let location: String
    var description: String?
    var image: String?
}

struct DashboardData: Decodable {
    let quickLinks: [QuickLink]
    let upcomingEvents: [Event]
}

// Homework Model
struct HomeworkItem: Identifiable, Codable {
    let id: Int
    var title: String
    var dueDate: String
    var status: String
    var type: String?
    var description: String?
}

// Bring Items Model
struct BringItem: Identifiable, Decodable {
    let id: Int
    let title: String
    let dueDate: String
    let status: String
}

// Notification Model
struct NotificationItem: Identifiable, Decodable {
    let id: Int
    let title: String
    let message: String
    let time: String
    var isRead: Bool
    let avatar: String
}

// Event Detail Model
struct EventDetail: Identifiable, Decodable {
    let id: Int
    let title: String
    let date: String
    let time: String
    let location: String
    let description: String
    let image: String
}

// Term Report and Monthly Exam Models
struct Subject: Identifiable, Decodable {
    var id: String { name }
    let name: String
    let marks: String
    let achievement: String
}

struct ReportData: Decodable {
    let subjects: [Subject]
}

// Meeting Model
struct Meeting: Identifiable, Decodable {
    let id: Int
    let title: String
    let date: String
    let time: String
    let description: String
    let status: String
}
