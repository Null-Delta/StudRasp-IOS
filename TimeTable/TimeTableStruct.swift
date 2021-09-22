//
//  TimeTableStruct.swift
//  TimeTable
//
//  Created by Рустам Хахук on 01.09.2021.
//

import Foundation
import UIKit


var mainDomain: String = "studrasp.ru"

// MARK: - Day
struct Day: Codable, Equatable {
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.lessons1 == rhs.lessons1 && lhs.lessons2 == rhs.lessons2
    }
    
    var lessons1, lessons2: [Lesson]

    func getLessons(date: Date, index: Int) -> [Lesson] {
        return date.weekIndex == 0 ? index == 0 ? lessons1 : lessons2 : index == 0 ? lessons2 : lessons1
    }
    
    mutating func changeLessons(date: Date, index: Int, action: (inout [Lesson]) ->()) {
        if(date.weekIndex != index) {
            action(&lessons2)
        } else {
            action(&lessons1)
        }
    }
}

// MARK: - Lesson
struct Lesson: Codable, Equatable {
    var name, teacherName, audience, type: String
    var lessonNumber: Int
    
    static var empty: Lesson {
        get {
            return Lesson(name: "", teacherName: "", audience: "", type: "", lessonNumber: 0)
        }
    }
}

struct LessonTime: Codable, Equatable {
    var start: Int
    var end: Int
}

class TimeTable: Codable, ObservableObject, Equatable, Identifiable {
    static func == (lhs: TimeTable, rhs: TimeTable) -> Bool {
        lhs.name == rhs.name &&
        lhs.firstWeek == rhs.firstWeek &&
        lhs.secondWeek == rhs.secondWeek &&
        lhs.days == rhs.days &&
        lhs.tableID == rhs.tableID &&
        lhs.lessonsTime == rhs.lessonsTime
    }
    
    @Published var name: String
    @Published var firstWeek: String
    @Published var secondWeek: String
    @Published var days: [Day]
    @Published var lessonsTime: [LessonTime]
    
    var id: String? = UUID().uuidString
    
    
    //@Published var times: [LessonTime]
    
    var tableID: Int?
    var invite_code: String?
    
    static var empty: TimeTable {
        get {
            return TimeTable(days: [
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: [])
            ], name: "", firstWeek: "", secondWeek: "", times: [
                LessonTime(start: 480, end: 570),
                LessonTime(start: 580, end: 670),
                LessonTime(start: 690, end: 780),
                LessonTime(start: 790, end: 880),
                LessonTime(start: 900, end: 990),
                LessonTime(start: 1000, end: 1090),
                LessonTime(start: 1100, end: 1190),
                LessonTime(start: 1200, end: 1290)
            ])
        }
    }
    
    var isEmpty: Bool {
        get {
            self.name.count == 0
        }
    }
    
    func getWeekName(date: Date, index: Int) -> String {
        return date.weekIndex == 0 ? index == 0 ? firstWeek : secondWeek : index == 0 ? secondWeek : firstWeek
    }
    
    enum CodingKeys: CodingKey {
        case name, firstWeek, secondWeek, days, lessonsTime, tableID
    }

    init(days: [Day], name: String, firstWeek: String, secondWeek: String, times: [LessonTime]) {
        self.days = days
        self.name = name
        self.firstWeek = firstWeek
        self.secondWeek = secondWeek
        self.lessonsTime = times
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        days = try container.decode([Day].self, forKey: .days)
        firstWeek = try container.decode(String.self, forKey: .firstWeek)
        secondWeek = try container.decode(String.self, forKey: .secondWeek)
        lessonsTime = try container.decode([LessonTime].self, forKey: .lessonsTime)
        tableID = try? container.decode(Optional<Int>.self, forKey: .tableID)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(days, forKey: .days)
        try container.encode(firstWeek, forKey: .firstWeek)
        try container.encode(secondWeek, forKey: .secondWeek)
        try container.encode(lessonsTime, forKey: .lessonsTime)
        try container.encode(tableID, forKey: .tableID)
    }
    
    func setValues(table: TimeTable) {
        name = table.name
        firstWeek = table.firstWeek
        secondWeek = table.secondWeek
        days = table.days
        tableID = table.tableID
    }
}


struct user: Codable {
    var login: String
    var session: String
    var email: String?
    
    static var empty: user {
        get {
            return user(login: "",session: "")
        }
    }
    
    var isEmpty: Bool {
        get {
            return login == "" && session == ""
        }
    }
}


struct loadTableRequest: Codable {
    var error: error
    var session: String?
    var login: String?
    var email: String?
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

class globalTableInfo: Codable, Identifiable {
    var name: String
    var tableID: String
    var invite_code: String?
    var id: String? = UUID().uuidString
    
    enum CodingKeys: CodingKey {
        case name, id, invite_code
    }
    
    init(name: String, tableID: String, invite_code: String?) {
        self.name = name
        self.tableID = tableID
        self.invite_code = invite_code
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        tableID = try container.decode(String.self, forKey: .id)
        invite_code = try container.decode(String.self, forKey: .invite_code)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(tableID, forKey: .id)
        try container.encode(invite_code, forKey: .invite_code)
    }
}
