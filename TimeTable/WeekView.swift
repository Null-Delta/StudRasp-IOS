//
//  WeekView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 02.09.2021.
//

import SwiftUI

struct WeekView: View {
    @Binding var date: Date
    @Binding var selectedDay: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .shadow(color: Color.shadow, radius: 8, x: 0, y: 4)
                
                .overlay(
                    Rectangle()
                        .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
                )
                
                .foregroundColor(Color.appBackground)

            HStack {
                ForEach(0..<7, id: \.self) { index in
                    DayView(date: .constant(date.startOfWeek.addDays(days: index)), selectedDay: $selectedDay, today: .constant(date.weekDay - 1), dayIndex: index)
                            .frame(height: 48)
                }
            }
            .padding(8)
            

        }
        .fixedSize(horizontal: false, vertical: true)
        .animation(.linear(duration: 0.1))
    }
}

struct DayView: View {
    @Binding var date: Date
    @Binding var selectedDay: Int
    @Binding var today: Int
    var dayIndex: Int

    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color.cardEnable, lineWidth: today == dayIndex ? 2 : 0)
                .background(selectedDay == dayIndex ? Color.cardEnable : Color.cardDisable)
                .cornerRadius(8)
                .shadow(color: Color.shadow.opacity(selectedDay == dayIndex ? 1 : 0), radius: 4, x: 0, y: 0)
            
            VStack {
                Text("\(date.dayAbr)")
                    .foregroundColor(selectedDay == dayIndex ? Color.cardDisable : Color.cardEnable)
                    .font(Font.appBold(size: 14))
                
                Text("\(date.day)")
                    .foregroundColor(selectedDay == dayIndex ? Color.cardDisable : Color.cardEnable)
                    .font(Font.appBold(size: 14))
            }
        }
        .onTapGesture {
            withAnimation(.linear) {
                selectedDay = dayIndex
            }
        }
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(date: .constant(Date(timeIntervalSinceNow: 0).addDays(days: 0)), selectedDay: .constant(3))
    }
}
