import XCTest
@testable import Canary

class CanaryTests: XCTestCase {
    
    func test_dateFormatting() {
        let today = Date(timeIntervalSinceNow: -120)
        let yesterday = Date(timeIntervalSinceNow: -87000)
        let twoDaysAgo = Date(timeIntervalSinceNow: -174000)
        let moreThanAWeekAgo = Date(timeIntervalSinceNow: -348000)
        let moreThanAMonthAgo = Date(timeIntervalSinceNow: -2764800)
        let moreThanAYearAgo = Date(timeIntervalSinceNow: -91708800)
        
        let tdf = ThoughtDateFormatter()
        
        let formattedToday = tdf.formattedString(from: today)
        let formattedYesterday = tdf.formattedString(from: yesterday)
        let formattedTwoDaysAgo = tdf.formattedString(from: twoDaysAgo)
        let formattedMoreThanAWeekAgo = tdf.formattedString(from: moreThanAWeekAgo)
        let formattedMoreThanAMonthAgo = tdf.formattedString(from: moreThanAMonthAgo)
        let formattedMoreThanAYearAgo = tdf.formattedString(from: moreThanAYearAgo)
        
        print(formattedToday)
        print(formattedYesterday)
        print(formattedTwoDaysAgo)
        print(formattedMoreThanAWeekAgo)
        print(formattedMoreThanAMonthAgo)
        print(formattedMoreThanAYearAgo)
        
        XCTFail("This isn't a complete test.")
    }
    
}
