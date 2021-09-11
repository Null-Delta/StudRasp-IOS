//
//  TimeTableEditor.swift.swift
//  TimeTable
//
//  Created by Рустам Хахук on 10.09.2021.
//

import SwiftUI

struct TimeTableEditor: View {
    @Binding var table: ServerTimeTable
    @State var selectedDay = 0
    @State var date = Date(timeIntervalSinceNow: 0)
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack(spacing: 0) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "multiply")
                    })
                        .frame(width: 36, height: 36)
                    
                    Spacer()
                    
                    Text(table.info.name)
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appBold(size: 24))
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "settings")
                    })
                        .frame(width: 36, height: 36)

                }
                .frame(height: 36)
                .padding(16)
                
                TableView(selectedDay: $selectedDay, activeTimeTable: $table, date: $date, isEditing: true)
            }
            
            WeekView(date: $date, selectedDay: $selectedDay)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

struct TimeTableEditorPreviews: PreviewProvider {
    static var previews: some View {
        TimeTableEditor(table: .constant(ServerTimeTable(id: -1, info: TimeTable(name: "aaa", firstWeek: "bbb", secondWeek: "ccc", days: [
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: [])
        ]))))
    }
}
