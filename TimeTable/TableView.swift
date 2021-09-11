//
//  TableView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 10.09.2021.
//

import SwiftUI

struct TableView: View {
    @Binding var selectedDay: Int
    @Binding var activeTimeTable: ServerTimeTable
    @Binding var date: Date
    @State var isEditing: Bool
    
    @State var isAddingLesson: Bool = false
    @State var selectedDayIndex: Int = 0
    
    func cardState(dayIndex: Int, lesson: Int) -> CardState {
        return (date.weekDay - 1 != dayIndex || isEditing) ?.highlight :
        (date.minutes < activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[lesson].start &&
         (lesson == 0 || date.minutes > activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[lesson - 1].end)) ? .wait :
        (date.minutes >= activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[lesson].start &&
         date.minutes <= activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[lesson].end) ? .active : .highlight
    }
    
    var body: some View {
        TabView(selection: $selectedDay) {
            ForEach(0..<7, id: \.self) {dayIndex in
                ScrollView {
                    if(!activeTimeTable.info.isEmpty) {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Текущая неделя")
                                    .foregroundColor(Color.cardEnableLight)
                                    .font(Font.appMedium(size: 16))
                                
                                Spacer()
                                
                                Text(activeTimeTable.info.getWeekName(date: date, index: 0))
                                    .foregroundColor(Color.cardEnableLight)
                                    .font(Font.appMedium(size: 16))
                            }
                            .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                            
                            VStack {
                                ForEach(0..<activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0).count, id: \.self) { index in
                                        Card(state: .constant(cardState(dayIndex: dayIndex, lesson: index)), lesson: .constant(activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[index]), date: $date)
                                }
                                
                                if(isEditing) {
                                    Button("Новая пара") {
                                        selectedDayIndex = 0
                                        isAddingLesson = true
                                    }
                                    .font(Font.appMedium(size: 20))
                                    .foregroundColor(Color.cardEnable)
                                    .frame(height: 36)
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8, style: .circular)
                                            .foregroundColor(Color.cardDisableLight)
                                    )
                                }
                                
                            }
                            
                            HStack {
                                Text("Следующая неделя")
                                    .foregroundColor(Color.cardEnableLight)
                                    .font(Font.appMedium(size: 16))
                                
                                Spacer()
                                
                                Text(activeTimeTable.info.getWeekName(date: date, index: 1))
                                    .foregroundColor(Color.cardEnableLight)
                                    .font(Font.appMedium(size: 16))
                            }
                            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
                            
                            VStack {
                                ForEach(0..<activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 1).count, id: \.self) { index in
                                    Card(state: .constant(CardState.highlight), lesson:
                                            .constant(activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 1)[index]), date: $date)
                                }
                                
                                if(isEditing) {
                                    Button("Новая пара") {
                                        selectedDayIndex = 1
                                        isAddingLesson = true
                                    }
                                    .font(Font.appMedium(size: 20))
                                    .foregroundColor(Color.cardEnable)
                                    .frame(height: 36)
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8, style: .circular)
                                            .foregroundColor(Color.cardDisableLight)
                                    )
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 80, trailing: 16))
                    }
            }
                .animation(.none)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .animation(.linear)
        .sheet(isPresented: $isAddingLesson, onDismiss: {
            
        }, content: {
            NewLessonView(table: $activeTimeTable, selectedDay: $selectedDay, dayIndex: $selectedDayIndex)
        } )
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(selectedDay: .constant(9), activeTimeTable: .constant(ServerTimeTable(id: -1, info: TimeTable(name: "Test", firstWeek: "aaa", secondWeek: "bbb", days: [
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: [])
        ]))), date: .constant(Date()), isEditing: true)
    }
}
