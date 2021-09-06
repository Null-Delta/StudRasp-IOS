//
//  TimeTableView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 01.09.2021.
//

import SwiftUI

struct TimeTableView: View {
    
    @Binding var activeTimeTable: ServerTimeTable
    @State var date: Date = Date(timeIntervalSinceNow: 0)
    @State var selectedDay: Int = -1
    @State var nowLesson: CardState = .wait
    @State var isSelectMenu = false
    
    let timer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Расписание")
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appBlack(size: 32))
                    
                    Spacer()
                    
                   
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                
                HStack {
                    Button(activeTimeTable.info.isEmpty ? "Выбрать" : activeTimeTable.info.name) {
                        isSelectMenu = true
                    }
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appMedium(size: 20))
                    
                    Spacer()
                }
                .frame(height: 36)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                
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
                                        if(activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0).count == 0) {
                                            Text("Сегодня пар нет")
                                                .foregroundColor(Color.cardEnableLight)
                                                .font(Font.appMedium(size: 16))
                                                .padding(24)
                                        } else {
                                            ForEach(0..<activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0).count, id: \.self) { index in
                                                if(date.weekDay - 1 != dayIndex) {
                                                    Card(state: .constant(CardState.highlight), lesson: .constant(activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[index]), date: $date)
                                                } else {
                                                    let state: CardState = (activeTimeTable.info.days[selectedDay].getLessons(date: date, index: 0).count > 0 &&  date.minutes > activeTimeTable.info.days[selectedDay].getLessons(date: date, index: 0)[index].end) ? .highlight : (date.minutes >= activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[index].start && date.minutes <= activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[index].end) ? .active : (date.minutes < activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[index].start && (index == 0 || date.minutes > activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[index - 1].end)) ? .wait : .highlight
                                                    
                                                    Card(state: .constant(state), lesson: .constant(activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 0)[index]), date: $date)
                                                }
                                            }
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
                                        if(activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 1).count == 0) {
                                            Text("Сегодня пар нет")
                                                .foregroundColor(Color.cardEnableLight)
                                                .font(Font.appMedium(size: 16))
                                                .padding(24)
                                        } else {
                                            ForEach(0..<activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 1).count, id: \.self) { index in
                                                Card(state: .constant(CardState.highlight), lesson:
                                                        .constant(activeTimeTable.info.days[dayIndex].getLessons(date: date, index: 1)[index]), date: $date)
                                            }
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
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                Spacer()
                WeekView(date: $date, selectedDay: $selectedDay)
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                date = Date(timeIntervalSinceNow: 0)
            }
        }
        .onAppear {
            date = Date(timeIntervalSinceNow: 0)
            if(selectedDay == -1) {
                selectedDay = date.weekDay - 1
            }
        }
        .sheet(isPresented: $isSelectMenu, content: {
            LoadTimeTableView(timeTable: $activeTimeTable)
        })
        .animation(.none)
        .background(Color.appBackground.ignoresSafeArea())

    }
}

struct TimeTableView_Previews: PreviewProvider {
    
    @State static var timeTable: TimeTable = TimeTable.empty
    
    static var previews: some View {
        TimeTableView(activeTimeTable: .constant(ServerTimeTable(id: -1, info: timeTable)))
    }
}
