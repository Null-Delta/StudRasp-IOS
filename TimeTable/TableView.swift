//
//  TableView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 10.09.2021.
//

import SwiftUI

struct Week: View {
    @State var isWeekNow: Bool
    @ObservedObject var activeTimeTable: TimeTable
    @Binding var date: Date
    @Binding var isEditing: Bool
    @State var dayIndex: Int
    
    @Binding var isAddingLesson: Bool
    @Binding var selectedDayIndex: Int
    
    @Binding var selectedLesson: Int?
    
    @State var isLessonActionsOpen = false
    
    //@State var isLessonSettingsOpen: Bool = false
    
    func cardState(dayIndex: Int, lesson: Int) -> CardState {
        
        if(isEditing && !isLesson(dayIndex: dayIndex, lesson: lesson)) {
            return .select
        } else if(isEditing) {
            return .highlight
        }
                
        return (date.weekDay - 1 != dayIndex) ? .highlight :
        (date.minutes < activeTimeTable.lessonsTime[lesson - 1].start &&
         ((activeTimeTable.days[dayIndex].getLessons(date: date, index: isWeekNow ? 0 : 1).first(where: {l in l.lessonNumber < lesson}) == nil) || date.minutes > activeTimeTable.lessonsTime[lesson - 2].end)) ? .wait :
        (date.minutes >= activeTimeTable.lessonsTime[lesson - 1].start &&
         date.minutes <= activeTimeTable.lessonsTime[lesson - 1].end) ? .active : .highlight
    }
    
    func isLesson(dayIndex: Int, lesson: Int) -> Bool {
        if(isWeekNow && date.weekIndex == 0 || !isWeekNow && date.weekIndex == 1) {
            return activeTimeTable.days[dayIndex].lessons1.first(where: {l in l.lessonNumber == lesson}) != nil
        } else {
            return activeTimeTable.days[dayIndex].lessons2.first(where: {l in l.lessonNumber == lesson}) != nil
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(isWeekNow ? "Текущая неделя" : "Следующая неделя")
                    .foregroundColor(Color.cardEnableLight)
                    .font(Font.appMedium(size: 16))
                
                Spacer()
                
                Text(activeTimeTable.getWeekName(date: date, index: isWeekNow ? 0 : 1))
                    .foregroundColor(Color.cardEnableLight)
                    .font(Font.appMedium(size: 16))
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
            
            if(isEditing) {
                ForEach(0..<8, id: \.self) {index in
                    Card(state: .constant(cardState(dayIndex: dayIndex, lesson: index + 1)), lesson: .constant(isLesson(dayIndex: dayIndex, lesson: index + 1) ? activeTimeTable.days[dayIndex].getLessons(date: date, index: isWeekNow ? 0 : 1).first(where: {l in l.lessonNumber == index + 1})! : Lesson(name: "", teacherName: "", audience: "", type: "", lessonNumber: index + 1)), date: $date, time: $activeTimeTable.lessonsTime[index])
                        .onTapGesture {
                            if(isEditing) {
                                selectedLesson = index + 1
                                selectedDayIndex = isWeekNow ? 0 : 1
                                isAddingLesson = true
                            }
                        }
                        .onLongPressGesture(minimumDuration: 0) {
                            if(isEditing && isLesson(dayIndex: dayIndex, lesson: index + 1)) {
                                selectedLesson = index + 1
                                selectedDayIndex = isWeekNow ? 0 : 1
                                isLessonActionsOpen = true
                            }
                        }
                }
            } else {
                ForEach(0..<activeTimeTable.days[dayIndex].getLessons(date: date, index: isWeekNow ? 0 : 1).count, id: \.self) { index in
                    Card(
                        state: .constant(isWeekNow ? cardState(dayIndex: dayIndex, lesson: activeTimeTable.days[dayIndex].getLessons(date: date, index: isWeekNow ? 0 : 1)[index].lessonNumber) : .highlight),
                        lesson: .constant(activeTimeTable.days[dayIndex].getLessons(date: date, index: isWeekNow ? 0 : 1)[index]),
                        date: $date,
                        time: $activeTimeTable.lessonsTime[activeTimeTable.days[dayIndex].getLessons(date: date, index: isWeekNow ? 0 : 1)[index].lessonNumber - 1])
                }
            }
            
            if(!isEditing && activeTimeTable.days[dayIndex].getLessons(date: date, index: isWeekNow ? 0 : 1).count == 0) {
                Text("Сегодня пар нет")
                    .padding(16)
                    .foregroundColor(Color.cardEnableLight)
                    .font(Font.appMedium(size: 16))
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(Color.cardDisableLight)
                    )
            }
        }
        .actionSheet(isPresented: $isLessonActionsOpen, content: {
            ActionSheet(title: Text("Действия"), message: nil, buttons: [
                ActionSheet.Button.destructive(Text("Удалить пару")) {
                    activeTimeTable.days[dayIndex].changeLessons(date: date, index: selectedDayIndex, action: {l in
                        l.removeAll(where: {t in t.lessonNumber == selectedLesson})
                    })
            },
                ActionSheet.Button.cancel()
            ])
        })
    }
}


struct TableView: View {
    @Binding var selectedDay: Int
    @ObservedObject var activeTimeTable: TimeTable
    @Binding var date: Date
    @State var isEditing: Bool
    
    @State var isAddingLesson: Bool = false
    
    @State var selectedLesson: Int? = nil
    
    @State var selectedDayIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedDay) {
            ForEach(0..<7, id: \.self) {dayIndex in
                ScrollView {
                    if(!activeTimeTable.isEmpty) {
                        VStack(spacing: 8) {
                            Week(isWeekNow: true, activeTimeTable: activeTimeTable, date: $date, isEditing: $isEditing, dayIndex: dayIndex, isAddingLesson: $isAddingLesson, selectedDayIndex: $selectedDayIndex, selectedLesson: $selectedLesson)
                            Week(isWeekNow: false, activeTimeTable: activeTimeTable, date: $date, isEditing: $isEditing, dayIndex: dayIndex, isAddingLesson: $isAddingLesson, selectedDayIndex: $selectedDayIndex, selectedLesson: $selectedLesson)                            
                        }
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 80, trailing: 16))
                    }
            }
                .animation(.none)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .sheet(isPresented: $isAddingLesson) {
            NewLessonView(table: activeTimeTable, selectedDay: $selectedDay, dayIndex: $selectedDayIndex, weekIndex: date.weekIndex, selectedLesson: $selectedLesson)
        }
        .animation(.linear)
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(selectedDay: .constant(5), activeTimeTable: (TimeTable(days: [
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: []),
            Day(lessons1: [], lessons2: [])
        ], name: "Test", firstWeek: "aaa", secondWeek: "bbb", times: [
            LessonTime(start: 0, end: 0),
            LessonTime(start: 10, end: 20),
            LessonTime(start: 0, end: 0),
            LessonTime(start: 0, end: 0),
            LessonTime(start: 0, end: 0),
            LessonTime(start: 0, end: 0),
            LessonTime(start: 0, end: 0),
            LessonTime(start: 0, end: 0)
        ])), date: .constant(Date()), isEditing: true)
    }
}
