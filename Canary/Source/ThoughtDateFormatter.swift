import Foundation

class ThoughtDateFormatter: DateFormatter {
    
    func formattedString(from date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            dateFormat = "HH:mm"
        } else if Calendar.current.isDateInYesterday(date) {
            dateFormat = "Yesterday at HH:mm"
        } else if date.timeIntervalSinceNow <= 518400 {
            dateFormat = "EEEE at HH:mm"
        } else if date.timeIntervalSinceNow <= 31536000 {
            dateFormat = "MMM d"
        } else {
            dateFormat = "MMM d yyyy"
        }
        return string(from: date)
    }
}
