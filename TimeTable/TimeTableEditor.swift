//
//  TimeTableEditor.swift.swift
//  TimeTable
//
//  Created by Рустам Хахук on 10.09.2021.
//

import SwiftUI


struct TimeTableEditor: View {
    @ObservedObject var tables: SavedTables
    
    @EnvironmentObject var timeTable: TimeTable
    @State var selectedDay = 0
    @State var date = Date(timeIntervalSinceNow: 0)
    @State var isShowSettings: Bool = false
    @State var isAddingTable: Bool = false
    
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack(spacing: 0) {
                    Button(action: {
                        
                        if(tables.selectedType == .local) {
                            if(tables.selectedID == timeTable.tableID) {
                                timeTable.setValues(table: tables.localTables.first(where: {t in t.tableID == tables.selectedID})!)
                                
                                UserDefaults.standard.set(String(data: try! JSONEncoder().encode(timeTable), encoding: .utf8)!, forKey: "timetable")
                                UserDefaults.standard.synchronize()

                                
                            }
                        }
                        //print(timeTable.name)
                        tables.saveArray(state: tables.selectedType)
                        tables.objectWillChange.send()
                        
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "multiply")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(Color.cardEnable)
                    })
                        .frame(width: 36, height: 36)
                    
                    Spacer()
                    
                    Text(tables.selectedType == .local ? tables.localTables[tables.selectedTable].name : (tables.isLoad(id: tables.globalTables[tables.selectedTable].tableID) ? tables.globalSavedTables[tables.globalSavedTables.firstIndex(where: {val in
                        val.id == Int(tables.globalTables[tables.selectedTable].tableID)!
                    })!].table.name : tables.globalTables[tables.selectedTable].name))
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appBold(size: 24))
                    
                    Spacer()
                    
                    Button(action: {
                        isShowSettings = true
                    }, label: {
                        Image(systemName: "gear")
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(Color.cardEnable)
                    })
                        .frame(width: 36, height: 36)

                }
                .frame(height: 36)
                .padding(16)
                
                Spacer()
                TableView(selectedDay: $selectedDay, activeTimeTable: tables.selectedType == .local ? tables.localTables[tables.selectedTable] : tables.globalSavedTables.first(where: {val in val.id == tables.selectedID})!.table, date: $date, isEditing: true)
            }
            
            WeekView(date: $date, selectedDay: $selectedDay, needBottomIgnore: false)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .sheet(isPresented: $isShowSettings, onDismiss: nil, content: {
            SettingsView(tables: tables)
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationTitle("")
    }
}

struct TimeTableEditorPreviews: PreviewProvider {
    @StateObject static var table = TimeTable(days: [
        Day(lessons1: [], lessons2: []),
        Day(lessons1: [], lessons2: []),
        Day(lessons1: [], lessons2: []),
        Day(lessons1: [], lessons2: []),
        Day(lessons1: [], lessons2: []),
        Day(lessons1: [], lessons2: []),
        Day(lessons1: [], lessons2: [])
    ], name: "aaa", firstWeek: "bbb", secondWeek: "ccc", times: [
        LessonTime(start: 0, end: 0),
        LessonTime(start: 0, end: 0),
        LessonTime(start: 0, end: 0),
        LessonTime(start: 0, end: 0),
        LessonTime(start: 0, end: 0),
        LessonTime(start: 0, end: 0),
        LessonTime(start: 0, end: 0),
        LessonTime(start: 0, end: 0)
    ])
    
    static var previews: some View {
        TimeTableEditor(tables: SavedTables())
    }
}
