//
//  NewLessonView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 10.09.2021.
//

import SwiftUI

struct NewLessonView: View {
    @ObservedObject var table: TimeTable
    
    //@Binding var day: Day
    @Binding var selectedDay: Int
    @Binding var dayIndex: Int
    @State var weekIndex: Int
    
    @Binding var selectedLesson: Int?
    
    @State var name: String = ""
    @State var teacherName: String = ""
    @State var audience: String = ""
    @State var lessonType: String = ""
    @State var timeStart: Int = -1
    @State var timeEnd: Int = -1
    @State var index: Int = -1
    
    @State var isSelectingValue: Bool = false
    @State var valuesArray: DefaultsName = DefaultsName.disciplines
    @State var valueTitle: String = "Дисциплины"
    
    @Environment(\.presentationMode) var presentationMode
    
    func getBindingField() -> Binding<String> {
        switch valuesArray {
        case .disciplines:
            return $name
        case .teacherNames:
            return $teacherName
        case .auditories:
            return $audience
        case .types:
            return $lessonType
        case .times:
            return $name
        }
    }

    func canCreate() -> Bool {
        return (
            name != "" &&
            teacherName != "" &&
            audience != "" &&
            lessonType != ""
        )
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $isSelectingValue, destination: {
                    ValueSelectorView(value: getBindingField(), title: $valueTitle, defaults: $valuesArray, action: {val in
                        switch valuesArray {
                        case .disciplines:
                            name = val
                        case .teacherNames:
                            teacherName = val
                        case .auditories:
                            audience = val
                        case .types:
                            lessonType = val
                        case .times:
                            name = val
                        }
                    })
                }, label: {})
                HStack {
                    Button("Отмена") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding(16)
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appMedium(size: 20))
                    
                    Spacer()
                    
                    Button("Добавить") {
                        table.days[selectedDay].changeLessons(date: Date(timeIntervalSinceNow: 0), index: dayIndex, action: {l in
                            l.removeAll(where: {l in l.lessonNumber == selectedLesson!})
                            l.append(Lesson(name: name, teacherName: teacherName, audience: audience, type: lessonType, lessonNumber: selectedLesson!))
                            l.sort(by: {l1, l2 in l1.lessonNumber < l2.lessonNumber })
                        })
                       
                        table.objectWillChange.send()
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
                            valuesArray = .disciplines
                            valueTitle = "Дисциплины"
                            isSelectingValue = true
                        }, label: {
                            Text(name == "" ? "Выбрать" : name)
                                .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
                                .multilineTextAlignment(.leading)
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
                        
                        Button(action: {
                            valuesArray = .teacherNames
                            valueTitle = "Преподаватели"
                            isSelectingValue = true
                        }, label: {
                            Text(teacherName == "" ? "Выбрать" : teacherName)
                                .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
                                .multilineTextAlignment(.leading)

                        })
                        
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

                        
                        Button(action: {
                            valuesArray = .auditories
                            valueTitle = "Аудитории"
                            isSelectingValue = true
                        }, label: {
                            Text(audience == "" ? "Выбрать" : audience)
                                .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                

                        })
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

                        Button(action: {
                            valuesArray = .types
                            valueTitle = "Тип пары"
                            isSelectingValue = true
                        }, label: {
                            Text(lessonType == "" ? "Выбрать" : lessonType)
                                .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                

                        })
                        .foregroundColor(lessonType == "" ? Color.cardEnableLight : Color.cardEnable)
                        .font(Font.appMedium(size: 16))
                        .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .foregroundColor(Color.cardDisableLight)
                        )
                    }
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)

                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                Spacer()
            }

        }
        .onAppear {
            if(selectedLesson != nil) {
                if let index = table.days[selectedDay].getLessons(date: Date(), index: dayIndex).firstIndex(where: {l in l.lessonNumber == selectedLesson!}) {
                    name = table.days[selectedDay].getLessons(date: Date(), index: dayIndex)[index].name
                    teacherName = table.days[selectedDay].getLessons(date: Date(), index: dayIndex)[index].teacherName
                    audience = table.days[selectedDay].getLessons(date: Date(), index: dayIndex)[index].audience
                    lessonType = table.days[selectedDay].getLessons(date: Date(), index: dayIndex)[index].type
                }
            }
        }
        .onOpenURL(perform: {url in
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct NewLessonView_Previews: PreviewProvider {
    static var previews: some View {
        NewLessonView(table: (TimeTable.empty), selectedDay: .constant(0), dayIndex: .constant(0), weekIndex: 0, selectedLesson: .constant(nil))
    }
}
