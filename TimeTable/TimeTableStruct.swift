//
//  TimeTableStruct.swift
//  TimeTable
//
//  Created by Рустам Хахук on 01.09.2021.
//

import Foundation

var mainDomain: String = "studrasp.ru"

struct Lesson: Codable {
    var name: String
    var teacherName: String
    var audience: String
    var type: String
    var index: Int?
    
    var start: Int
    var end: Int
    
    static var empty: Lesson {
        get {
            return Lesson(name: "", teacherName: "", audience: "", type: "", index: 0, start: 0, end: 0)
        }
    }
}

struct Day: Codable {
    var lessons1: [Lesson]
    var lessons2: [Lesson]
    
    func getLessons(date: Date, index: Int) -> [Lesson] {
        return date.weekIndex == 0 ? index == 0 ? lessons1 : lessons2 : index == 0 ? lessons2 : lessons1
    }
}

struct TimeTable: Codable {
    var name: String
    var firstWeek: String
    var secondWeek: String
    
    var days: [Day]
    
    static var empty: TimeTable {
        get {
            var tt = TimeTable(name: "", firstWeek: "", secondWeek: "", days: [])
            
            tt.days.append(Day(lessons1: [], lessons2: []))
            tt.days.append(Day(lessons1: [], lessons2: []))
            tt.days.append(Day(lessons1: [], lessons2: []))
            tt.days.append(Day(lessons1: [], lessons2: []))
            tt.days.append(Day(lessons1: [], lessons2: []))
            tt.days.append(Day(lessons1: [], lessons2: []))
            tt.days.append(Day(lessons1: [], lessons2: []))

            return tt;
        }
    }
    
    var isEmpty: Bool {
        get {
            return self.name.count == 0
        }
    }
    
    func getWeekName(date: Date, index: Int) -> String {
        return date.weekIndex == 0 ? index == 0 ? firstWeek : secondWeek : index == 0 ? secondWeek : firstWeek
    }
}

struct ServerTimeTable: Codable {
    var id: Int
    var info: TimeTable
}


struct user: Codable {
    var login: String
    var session: Int
    
    static var empty: user {
        get {
            return user(login: "",session: -1)
        }
    }
    
    var isEmpty: Bool {
        get {
            return login == "" && session == -1
        }
    }
}
