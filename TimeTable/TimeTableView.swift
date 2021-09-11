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
                    
                TableView(selectedDay: $selectedDay, activeTimeTable: $activeTimeTable, date: $date, isEditing: false)
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
            
            WeekView(date: $date, selectedDay: $selectedDay, needBottomIgnore: false)
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
