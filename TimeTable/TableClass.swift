//
//  TableClass.swift
//  TimeTable
//
//  Created by Рустам Хахук on 11.09.2021.
//

import Foundation
//
//class ServerTable: Codable, ObservableObject {
//    @Published var info: TableStruct
//    @Published var id: String
//
//    var empty: ServerTable {
//        get {
//            return ServerTable(id: "-1", info: TableStruct.empty)
//        }
//    }
//
//    enum CodingKeys: CodingKey {
//        case info, id
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        info = try container.decode(TableStruct.self, forKey: .info)
//        id = try container.decode(String.self, forKey: .id)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(info, forKey: .info)
//        try container.encode(id, forKey: .id)
//    }
//
//    init(id i: String, info inf: TableStruct) {
//        id = i
//        info = inf
//    }
//}
//
//class TableStruct: Codable, ObservableObject {
//    @Published var days: [DayStruct]
//    @Published var name: String
//    @Published var firstWeek : String
//    @Published var secondWeek: String
//
//    var isEmpty: Bool {
//        get {
//            return self.name.count == 0
//        }
//    }
//
//    static var empty: TableStruct {
//        get {
//            return TableStruct(days: [
//                DayStruct(lessons1: [], lessons2: []),
//                DayStruct(lessons1: [], lessons2: []),
//                DayStruct(lessons1: [], lessons2: []),
//                DayStruct(lessons1: [], lessons2: []),
//                DayStruct(lessons1: [], lessons2: []),
//                DayStruct(lessons1: [], lessons2: []),
//                DayStruct(lessons1: [], lessons2: [])
//            ], name: "Без имени", firstWeek: "", secondWeek: "")
//        }
//    }
//
//    enum CodingKeys: CodingKey {
//        case name, firstWeek, secondWeek, days
//    }
//
//    init(days: [DayStruct], name: String, firstWeek: String, secondWeek: String) {
//        self.days = days
//        self.name = name
//        self.firstWeek = firstWeek
//        self.secondWeek = secondWeek
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decode(String.self, forKey: .name)
//        days = try container.decode([DayStruct].self, forKey: .days)
//        firstWeek = try container.decode(String.self, forKey: .firstWeek)
//        secondWeek = try container.decode(String.self, forKey: .secondWeek)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//        try container.encode(days, forKey: .days)
//        try container.encode(firstWeek, forKey: .firstWeek)
//        try container.encode(secondWeek, forKey: .secondWeek)
//    }
//
//    func loadFromJson(json: Data) {
//        let tbl = try! JSONDecoder().decode(TableStruct.self, from: json)
//
//        self.name = tbl.name
//        self.firstWeek = tbl.firstWeek
//        self.secondWeek = tbl.secondWeek
//        self.days = tbl.days
//
//        objectWillChange.send()
//    }
//
//    func copyFromTable(tbl: TableStruct) {
//        self.name = tbl.name
//        self.firstWeek = tbl.firstWeek
//        self.secondWeek = tbl.secondWeek
//        self.days = tbl.days
//
//        objectWillChange.send()
//    }
//}
//
//// MARK: - Day
//class DayStruct: Codable {
//    var lessons1, lessons2: [LessonStruct]
//
//    init(lessons1: [LessonStruct], lessons2: [LessonStruct]) {
//        self.lessons1 = lessons1
//        self.lessons2 = lessons2
//    }
//
//    func getLessons(date: Date, index: Int) -> [LessonStruct] {
//        return date.weekIndex == 0 ? index == 0 ? lessons1 : lessons2 : index == 0 ? lessons2 : lessons1
//    }
//}
//
//// MARK: - Lesson
//class LessonStruct: Codable {
//    var name, teacherName, audience, type: String
//    var start, end, lessonNumber: Int
//
//    init(name: String, teacherName: String, audience: String, type: String, start: Int, end: Int, lessonNumber: Int) {
//        self.name = name
//        self.teacherName = teacherName
//        self.audience = audience
//        self.type = type
//        self.start = start
//        self.end = end
//        self.lessonNumber = lessonNumber
//    }
//}
