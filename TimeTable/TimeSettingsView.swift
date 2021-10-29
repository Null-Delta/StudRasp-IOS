//
//  TimeSettingsView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 19.09.2021.
//

import SwiftUI

struct TimeSettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var tables: SavedTables
    
    @State var dates: [(Date, Date)] = [
        (Date(),Date()),
        (Date(),Date()),
        (Date(),Date()),
        (Date(),Date()),
        (Date(),Date()),
        (Date(),Date()),
        (Date(),Date()),
        (Date(),Date())
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button("Назад") {
                    if tables.selectedType == .global {
                        for i in 0..<tables.globalSavedTables.first(where: {t in t.id == tables.selectedID})!.table.lessonsTime.count {
                            tables.globalSavedTables.first(where: {t in t.id == tables.selectedID})!.table.lessonsTime[i].start = dates[i].0.minutes
                            tables.globalSavedTables.first(where: {t in t.id == tables.selectedID})!.table.lessonsTime[i].end = dates[i].1.minutes
                        }
                        tables.saveArray(state: .global)
                    } else {
                        for i in 0..<tables.localTables[tables.selectedTable].lessonsTime.count {
                            tables.localTables[tables.selectedTable].lessonsTime[i].start = dates[i].0.minutes
                            tables.localTables[tables.selectedTable].lessonsTime[i].end = dates[i].1.minutes
                        }
                        tables.saveArray(state: .local)
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.cardEnable)
                .font(Font.appMedium(size: 20))
                .padding(16)
                Spacer()
            }
            
            Text("Время пар")
                .font(Font.appBold(size: 32))
                .foregroundColor(Color.cardEnable)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 0))
            
            ScrollView() {
                ForEach(0..<8, id: \.self) { index in
                    HStack(spacing: 8) {
                        ZStack (alignment: .center){
                            Circle()
                                .frame(width: 24, height: 24, alignment: .center)
                                .foregroundColor(Color.cardDisableLight)
                            Text("\(index + 1)")
                                .font(Font.appBold(size: 12))
                                .foregroundColor(Color.cardEnable)
                        }
                        
                        Spacer()
                        
                        DatePicker(selection: $dates[index].0, displayedComponents: .hourAndMinute, label: {
                            Text("От:")
                                .fixedSize()
                                .font(Font.appMedium(size: 16))
                                .foregroundColor(Color.cardEnableLight)
                                //.background(Color.red)
                        })
                            .fixedSize()
                            .accentColor(Color.cardEnable)
                        
                        DatePicker(selection: $dates[index].1, displayedComponents: .hourAndMinute, label: {
                            Text("До:")
                                .fixedSize()
                                .font(Font.appMedium(size: 16))
                                .foregroundColor(Color.cardEnableLight)
                        })
                            .fixedSize()
                            .accentColor(Color.cardEnable)


                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                }
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
           // dates = []
            if tables.selectedType == .global {
                for i in tables.globalSavedTables.first(where: {t in t.id == tables.selectedID})!.table.lessonsTime.enumerated() {
                    dates[i.offset] = (Date().startOfWeek.addMinutes(minutes: i.element.start), Date().startOfWeek.addMinutes(minutes: i.element.end))
                }
            } else {
                for i in tables.localTables[tables.selectedTable].lessonsTime.enumerated() {
                    dates[i.offset] = (Date().startOfWeek.addMinutes(minutes: i.element.start), Date().startOfWeek.addMinutes(minutes: i.element.end))
                }
            }
        }
    }
}

struct TimeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSettingsView(tables: SavedTables())
    }
}
