//
//  NewLessonView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 10.09.2021.
//

import SwiftUI

struct NewLessonView: View {
    @Binding var table: ServerTimeTable
    @Binding var selectedDay: Int
    @Binding var dayIndex: Int
    var selectedLesson: Int?
    
    @State var name: String = ""
    @State var teacherName: String = ""
    @State var audience: String = ""
    @State var lessonType: String = ""
    @State var timeStart: Int = -1
    @State var timeEnd: Int = -1
    @State var index: Int = -1
    
    @State var isSelectingValue: Bool = false
    @State var valuesArray: DefaultsName = DefaultsName.disciplines
    @State var selectedField: Binding<String> = .constant("")
    @State var valueTitle: String = ""
    
    @Environment(\.presentationMode) var presentationMode

    func canCreate() -> Bool {
        return (
            name != "" &&
            teacherName != "" &&
            audience != "" &&
            lessonType != ""// &&
            //timeStart != -1 &&
            //timeEnd != -1
        )
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Button("Отмена") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(16)
                .foregroundColor(Color.cardEnable)
                .font(Font.appMedium(size: 20))
                
                Spacer()
                
                Button("Добавить") {
                    var tbl = table
                    
                    //tbl.info.name = "aaaaaa"

                    if(selectedLesson == nil) {
                        if(dayIndex == 0) {
                            tbl.info.days[selectedDay].lessons1.append(
                                Lesson(name: name, teacherName: teacherName, audience: audience, type: lessonType, index: index, start: timeStart, end: timeEnd)
                            )
                            tbl.info.days[selectedDay].lessons1.sort(by: {l1, l2 in l1.start > l2.start })
                        } else {
                            tbl.info.days[selectedDay].lessons2.append(
                                Lesson(name: name, teacherName: teacherName, audience: audience, type: lessonType, index: index, start: timeStart, end: timeEnd)
                            )
                            tbl.info.days[selectedDay].lessons2.sort(by: {l1, l2 in l1.start > l2.start })
                        }
                    } else {
                        if(dayIndex == 0) {
                            tbl.info.days[selectedDay].lessons1[selectedLesson!] = Lesson(name: name, teacherName: teacherName, audience: audience, type: lessonType, index: index, start: timeStart, end: timeEnd)
                        } else {
                            tbl.info.days[selectedDay].lessons2[selectedLesson!] = Lesson(name: name, teacherName: teacherName, audience: audience, type: lessonType, index: index, start: timeStart, end: timeEnd)
                        }
                    }
                    
                    table = tbl
                    
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(16)
                .foregroundColor(canCreate() ? Color.cardEnable : Color.cardDisable)
                .font(Font.appMedium(size: 20))
                .disabled(!canCreate())
            }
            
            ScrollView {
                VStack(spacing: 8) {
                    Text("Название дисциплины")
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appBold(size: 16))
                        .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)

                    
                    Button(action: {
                        selectedField = $name
                        valuesArray = .disciplines
                        valueTitle = "Дисциплины"
                        isSelectingValue = true
                    }, label: {
                        Text(name == "" ? "Выбрать" : name)
                            .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)

                    })
                    .foregroundColor(name == "" ? Color.cardEnableLight : Color.cardEnable)
                    .font(Font.appMedium(size: 16))
                    .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(Color.cardDisableLight)
                    )
                    
                    Text("Имя преподавателя")
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appBold(size: 16))
                        .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)

                    
                    Button(teacherName == "" ? "Выбрать" : teacherName) {
                        selectedField = $teacherName
                        valuesArray = .teacherNames
                        valueTitle = "Преподаватели"
                        isSelectingValue = true
                    }
                    .foregroundColor(teacherName == "" ? Color.cardEnableLight : Color.cardEnable)
                    .font(Font.appMedium(size: 16))
                    .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(Color.cardDisableLight)
                    )
                    
                    Text("Аудитория")
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appBold(size: 16))
                        .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)

                    
                    Button(audience == "" ? "Выбрать" : audience) {
                        selectedField = $audience
                        valuesArray = .auditories
                        valueTitle = "Аудитории"
                        isSelectingValue = true
                    }
                    .foregroundColor(audience == "" ? Color.cardEnableLight : Color.cardEnable)
                    .font(Font.appMedium(size: 16))
                    .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(Color.cardDisableLight)
                    )
                    
                    Text("Тип пары")
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appBold(size: 16))
                        .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)

                    
                    Button(lessonType == "" ? "Выбрать" : lessonType) {
                        selectedField = $lessonType
                        valuesArray = .types
                        valueTitle = "Тип пары"
                        isSelectingValue = true
                    }
                    .foregroundColor(lessonType == "" ? Color.cardEnableLight : Color.cardEnable)
                    .font(Font.appMedium(size: 16))
                    .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(Color.cardDisableLight)
                    )
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            
            Spacer()
        }
        .sheet(isPresented: $isSelectingValue, content: {
            ValueSelectorView(value: selectedField, title: valueTitle, defaults: valuesArray)
        })
    }
}

struct NewLessonView_Previews: PreviewProvider {
    static var previews: some View {
        NewLessonView(table: .constant(ServerTimeTable(id: -1, info: TimeTable.empty)), selectedDay: .constant(0), dayIndex: .constant(0))
    }
}
