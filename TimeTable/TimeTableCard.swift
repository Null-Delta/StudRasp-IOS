//
//  TimeTableCard.swift
//  TimeTable
//
//  Created by Рустам Хахук on 08.09.2021.
//

import SwiftUI

enum TimeTableState {
    case local, global, changed
}

struct TimeTableCard: View {
    @State var state: TimeTableState = .changed
    @State var name: String = "Расписание"
    @State var code: String = "1234"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .foregroundColor(state == .changed ? Color.warning : Color.cardDisableLight)
            
            HStack(spacing: 4) {
                Text("Расписание")
                    .foregroundColor(state == .changed ? Color.warningEnable : Color.cardEnable)
                    .font(Font.appBold(size: 16))
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                
                if(state != .local) {
                    Text("1234")
                        .foregroundColor(state == .changed ? Color.warningDisable : Color.cardEnableLight)
                        .font(Font.appBold(size: 16))
                }
                
                Spacer()
                
                if(state == .changed) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "arrow.up.to.line.alt")
                            .font(Font.system(size: 16, weight: .heavy, design: .default))
                            .foregroundColor(Color.warningEnable)
                            .frame(width: 36, height: 36, alignment: .center)
                    })
                }
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(state == .changed ? Color.warningEnable : Color.cardEnable)
                        .font(Font.system(size: 16, weight: .heavy, design: .default))
                        .frame(width: 36, height: 36, alignment: .center)
                })
            }
        }
        .frame(height: 36, alignment: .center)
        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
    }
}

struct TimeTableCard_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableCard()
            .padding(16)
    }
}
