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
    @Binding var state: TimeTableState
    @Binding var name: String
    @Binding var code: String?
    
    var onDelete: () -> () = {}
    var onShare: () -> () = {}
    var onSet: () -> () = {}
    var onChangesDelete: () -> () = {}
    
    @State var isActionsOpen: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .foregroundColor(state == .changed ? Color.warning : Color.cardDisableLight)
            
            HStack(spacing: 4) {
                Text(name)
                    .foregroundColor(state == .changed ? Color.warningEnable : Color.cardEnable)
                    .font(Font.appBold(size: 16))
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                
                if(state != .local) {
                    Text(code ?? "")
                        .foregroundColor(state == .changed ? Color.warningDisable : Color.cardEnableLight)
                        .font(Font.appBold(size: 16))
                }
                
                Spacer()
                
                if(state == .changed) {
                    Button(action: {
                        onShare()
                    }, label: {
                        Image(systemName: "arrow.up.to.line.alt")
                            .font(Font.system(size: 16, weight: .heavy, design: .default))
                            .foregroundColor(Color.warningEnable)
                            .frame(width: 36, height: 36, alignment: .center)
                    })
                }
                
                Button(action: {
                    isActionsOpen = true
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
        .actionSheet(isPresented: $isActionsOpen, content: {
            var btns = [
//                ActionSheet.Button.default(Text("Использовать"), action: {
//                    onSet()
//                }),
                ActionSheet.Button.destructive(Text("Удалить"), action: {
                    onDelete()
                }),
                ActionSheet.Button.cancel()
            ]
            if state == .local {
                btns.insert(Alert.Button.default(Text("Опубликовать"), action:  {
                    onShare()
                }), at: 0)
            }
            
            if state != .local  {
                btns.insert(Alert.Button.default(Text("Копировать ссылку"), action:  {
                    UIPasteboard.general.string = "studrasp://addTable/" + code!
                }), at: 0)
            }
            
            if state == .changed {
                btns.insert(Alert.Button.destructive(Text("Удалить изменения"), action:  {
                    onChangesDelete()
                }), at: btns.count - 2)
            }
            return ActionSheet(title: Text(name), message: nil, buttons: btns)
        })
    }
}

struct TimeTableCard_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableCard(state: .constant(.changed), name: .constant(""), code: .constant(""))
            .padding(16)
    }
}
