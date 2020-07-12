//
//  DateTesterTests.swift
//  DateTesterTests
//
//  Created by Jerry Carter on 7/11/20.
//

import XCTest
@testable import DateTester

class DateTesterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceCreateEachTime() throws {
        // This is an example of a performance test case.
        self.measure {
            for _ in 0..<10000 {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ssX"
                _ = formatter.date(from: "2020-02-03 12:34:56+04")
            }
        }
    }

    func testPerformanceCached() throws {
        // This is an example of a performance test case.
        let formatter2 = DateFormatter()
        formatter2.locale = Locale(identifier: "en_US_POSIX")
        formatter2.timeZone = TimeZone(secondsFromGMT: 0)
        formatter2.dateFormat = "yyyy-MM-dd"

        let formatter1 = DateFormatter()
        formatter1.locale = Locale(identifier: "en_US_POSIX")
        formatter1.timeZone = TimeZone(secondsFromGMT: 0)
        formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let formatter0 = DateFormatter()
        formatter0.locale = Locale(identifier: "en_US_POSIX")
        formatter0.timeZone = TimeZone(secondsFromGMT: 0)
        formatter0.dateFormat = "yyyy-MM-dd HH:mm:ssX"

        self.measure {
            for _ in 0..<3333 {
                _ = formatter2.date(from: "2020-02-03 12:34:56+04")
                _ = formatter1.date(from: "2020-02-03 12:34:56")
                _ = formatter0.date(from: "2020-02-03")
            }
            _ = formatter2.date(from: "2020-02-03 12:34:56+04")
        }
    }
    
    func testPerformanceCreateISOEachTime() throws {
        // This is an example of a performance test case.
        self.measure {
            for _ in 0..<10000 {
                let formatter = ISO8601DateFormatter()
                _ = formatter.date(from: "2020-02-03T12:34:56+04")
            }
        }
    }

    func testPerformanceCachedISO() throws {
        let formatter = ISO8601DateFormatter()
        self.measure {
            for _ in 0..<10000 {
                _ = formatter.date(from: "2020-02-03T12:34:56+04")
            }
        }
    }

    func testPerformanceComponents() throws {
        self.measure {
            for _ in 0..<10000 {
                let x = DateComponents(calendar: Calendar(identifier: .iso8601), timeZone: TimeZone(secondsFromGMT: 240), year: 2020, month: 2, day: 3, hour: 12, minute: 34, second: 56)
                _ = x.date
            }
        }
    }

    func testPerformanceComponentsSharedCalendar() throws {
        let calendar = Calendar(identifier: .iso8601)
        self.measure {
            for _ in 0..<10000 {
                let x = DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 240), year: 2020, month: 2, day: 3, hour: 12, minute: 34, second: 56)
                _ = x.date
            }
        }
    }
    
    func testPerformanceSwitchingFormat() throws {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        self.measure {
            for i in 0..<10000 {
                switch i % 3 {
                case 0:
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ssX"
                    _ = formatter.date(from: "2020-02-03 12:34:56+04")
                case 1:
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    _ = formatter.date(from: "2020-02-03 12:34:56")
                case 2:
                    formatter.dateFormat = "yyyy-MM-dd"
                    _ = formatter.date(from: "2020-02-03")
                default:
                    abort()
                }
            }
        }
    }
    
    private static let regex = try! NSRegularExpression(pattern:
      "^(?<year>[0-9]{4})-(?<month>[0-9]{2})-(?<day>[0-9]{2})(?: (?<hour>[0-9]{2}):(?<min>[0-9]{2}):(?<sec>[0-9]{2})(?<micro>\\.[0-9]{1,6})?(?:(?<tzhr>[-+][0-9]{1,4})(?:[:](?<tzmin>[0-9]{2}))?)?)?"
        )
    
    func testJerrysFunction() throws {
        let title = "2020-02-03 12:34:56+04"
        let calendar = Calendar(identifier: .iso8601)
        
        self.measure {
            for _ in 0..<10000 {
                var year:Int?
                var month:Int?
                var day:Int?
                var hour:Int?
                var minute:Int?
                var second:Int?
                var nano:Int?
                var minutesFromGMT:Int = 0

                if let match = DateTesterTests.regex.firstMatch(in: title, range: NSRange(location: 0, length: title.count)) {
                    if let yearRange = Range(match.range(withName: "year"), in: title) {
                        year = Int(title[yearRange])
                    }
                    if let monthRange = Range(match.range(withName: "month"), in: title) {
                        month = Int(title[monthRange])
                    }
                    if let dayRange = Range(match.range(withName: "day"), in: title) {
                        day = Int(title[dayRange])
                    }
                    
                    if let hourRange = Range(match.range(withName: "hour"), in: title) {
                        hour = Int(title[hourRange])
                        
                        if let minuteRange = Range(match.range(withName: "min"), in: title) {
                            minute = Int(title[minuteRange])
                        }
                        if let secondRange = Range(match.range(withName: "sec"), in: title) {
                            second = Int(title[secondRange])
                        }
                        if let microRange = Range(match.range(withName: "micro"), in: title) {
                            if let micro = Float(title[microRange]) {
                                nano = Int(micro * 1e9)
                            }
                        }
                    }
                            
                    if let tzhrRange = Range(match.range(withName: "tzhr"), in: title) {
                        if let tzhr = Int(title[tzhrRange]) {
                            minutesFromGMT = 60*tzhr
                            
                            if let tzminRange = Range(match.range(withName: "tzmin"), in: title) {
                                if let tzmin = Int(title[tzminRange]) {
                                    if minutesFromGMT > 0 { minutesFromGMT += tzmin }
                                    else { minutesFromGMT -= tzmin }
                                }
                            }
                        }
                    }
                
                    let date = DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nano).date
                    _ = date?.advanced(by: TimeInterval(minutesFromGMT * -60))
                }
            }
        }
    }
}


// now()::date                  2020-07-12
// now()::timestamp             2020-07-12 09:50:27.730266
// now()                        2020-07-12 09:49:03.496194-04
