import EventKit
import SwiftUI

class EventKitManager: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var calendarAccessGranted = false
    
    init() {
        checkCalendarAuthorization()
    }
    
    func checkCalendarAuthorization() {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:
            self.calendarAccessGranted = true
        case .notDetermined:
            requestAccess()
        case .denied, .restricted:
            self.calendarAccessGranted = false
        @unknown default:
            self.calendarAccessGranted = false
        }
    }
    
    func requestAccess() {
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.calendarAccessGranted = granted
            }
        }
    }
    
    func addEventToCalendar(title: String, startDate: Date, endDate: Date, location: String, notes: String) -> Bool {
        guard calendarAccessGranted else {
            requestAccess()
            return false
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.location = location
        event.notes = notes
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent, commit: true)
            return true
        } catch {
            print("Error saving event: \(error)")
            return false
        }
    }
}
