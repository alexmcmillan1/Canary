import Foundation

class ThoughtDateFormatter: DateFormatter {
    
    func formattedString(from date: Date) -> String {
        var prefix = ""
        if Calendar.current.isDateInToday(date) {
            prefix = "Today, "
            dateFormat = "HH:mm"
        } else if Calendar.current.isDateInYesterday(date) {
            prefix = "Yesterday, "
            dateFormat = "HH:mm"
        } else if date.timeIntervalSinceNow > -518400 {
            dateFormat = "EEEE, HH:mm"
        } else if date.timeIntervalSinceNow > -31536000 {
            dateFormat = "MMM d"
        } else {
            dateFormat = "MMM d, yyyy"
        }
        return "\(prefix)\(string(from: date))"
    }
    
}
