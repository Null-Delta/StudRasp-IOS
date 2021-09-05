//
//  Card.swift
//  TimeTable
//
//  Created by Рустам Хахук on 01.09.2021.
//

import SwiftUI

enum CardState {
    case active, disable, highlight, wait
}

struct Card: View {
    @Binding var state: CardState
    @Binding var lesson: Lesson
    @Binding var date: Date
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .foregroundColor(state == .disable ? .clear : state == .wait ? Color.cardEnable : Color.cardDisable)
            
            VStack {
                if(state == .wait) {
                    HStack {
                        Text("До начала пары")
                            .foregroundColor(Color.cardDisable)
                            .font(Font.appBold(size: 14))
                        Spacer()
                        Text("\((lesson.start - date.minutes) / 60)ч \((lesson.start - date.minutes) % 60)м")
                            .foregroundColor(Color.cardDisable)
                            .font(Font.appBold(size: 14))
                    }
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(state == .disable ? Color.cardDisable : Color.clear, lineWidth: 2)
                        .background((state == .highlight || state == .wait) ? Color.cardDisable : state == .active ? Color.cardEnable : Color.clear)
                        .cornerRadius(8, antialiased: true)
                        .shadow(color: Color.cardEnable.opacity( state == .active ? 0.5 : 0), radius: 8, x: 0, y: 4)

                        
                    VStack(spacing: 8) {
                        HStack {
                            Text(lesson.name)
                                .foregroundColor(state == .active ? Color.appBackground : Color.cardEnable)
                                .font(Font.appBold(size: 16))
                            
                            Spacer()
                            
                            Text("\(lesson.audience) / \(lesson.type)")
                                .foregroundColor(state == .active ? Color.appBackground : Color.cardEnable)
                                .font(Font.appMedium(size: 14))
                        }
                        
                        HStack {
                            Text(lesson.teacherName)
                                .foregroundColor(state == .active ? Color.appBackground : Color.cardEnable)
                                .font(Font.appMedium(size: 14))

                            Spacer()
                            
                            Text("\(numToTime(num: lesson.start)) - \(numToTime(num: lesson.end))")
                                .foregroundColor(state == .active ? Color.appBackground : Color.cardEnable)
                                .font(Font.appMedium(size: 14))
                        }
                    }
                    .padding(8)
                }
                
                if(state == .active) {
                    HStack {
                        Text("До конца пары")
                            .foregroundColor(Color.cardEnable)
                            .font(Font.appBold(size: 14))
                        
                        Spacer()
    
                        Text("\((lesson.end - date.minutes) / 60)ч \((lesson.end - date.minutes) % 60)м")
                            .foregroundColor(Color.cardEnable)
                            .font(Font.appBold(size: 14))
                    }
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .animation(.none)
    }

    func numToTime(num: Int) -> String {
        let hours = "\(num / 60)"
        var minutes = "\(num % 60)"

        if minutes.count == 1 { minutes = "0" + minutes }
        
        return hours + ":" + minutes
    }
}

struct Card_Previews: PreviewProvider {
    @State static var state : CardState = .wait
    @State static var lesson: Lesson = Lesson(name: "Дискретка", teacherName: "Жук А.С.", audience: "A305", type: "Лк", start: 480, end: 570)
    
    static var previews: some View {
        
        VStack {
            Card(state: $state, lesson: $lesson, date: .constant(Date()))
                
            Button("test", action: {
                lesson.name = "aaa"
                if(state == .wait) {
                    state = .active
                } else {
                    state = .wait
                }
            })
        }
    }
}