//
//  TimeTableStruct.swift
//  TimeTable
//
//  Created by Рустам Хахук on 01.09.2021.
//

import Foundation
import UIKit


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
    
    var lastUpdateDate: String? = nil
    
    var days: [Day]
    
    static var empty: TimeTable {
        get {
            return TimeTable(name: "", firstWeek: "", secondWeek: "", days: [
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: []),
                Day(lessons1: [], lessons2: [])
            ])
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
    var session: String
    
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
    var timetable: ServerTimeTable?
    var session: String?
    var login: String?
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}


class TableObserved: ObservableObject {
    @Published var table: ServerTimeTable
    
    init(table tbl: ServerTimeTable) {
        table = tbl
    }
}
