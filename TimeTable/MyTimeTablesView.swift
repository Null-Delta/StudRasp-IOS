//
//  MyTimeTablesView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 08.09.2021.
//

import SwiftUI


struct MyTimeTablesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var globalTables: [ServerTimeTable] = []
    @State var localTables: [ServerTimeTable] = []
    
    @State var selectedTable: Binding<ServerTimeTable> = .constant(ServerTimeTable(id: -1, info: TimeTable.empty))
    
    @State var isEditorOpen: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button("Назад") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.cardEnable)
                .font(Font.appMedium(size: 20))
                .frame(height: 42)
                
                Spacer()
                
                Button("Добавить") {
                    var table = ServerTimeTable(id: -1, info: TimeTable.empty)
                    table.info.name = "Без имени"
                    localTables.append(table)
                    selectedTable = $localTables.last!
                    isEditorOpen = true
                }
                .foregroundColor(Color.cardEnable)
                .font(Font.appMedium(size: 20))
                .frame(height: 42)
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            
            HStack() {
                Text("Мои расписания")
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appBold(size: 32))
                    .frame(height: 42)
                Spacer()
                
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

            
            ScrollView() {
                VStack(spacing: 0) {
                    if(globalTables.count != 0)  {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Опубликованые")
                                    .foregroundColor(Color.cardEnable)
                                    .font(Font.appBold(size: 16))
                                    .frame(height: 36)
                                Spacer()
                            }
                            
                            ForEach(0..<globalTables.count) { index in
                                TimeTableCard(state: .global, name: "Расписание \(index)", code: "\(index)")
                            }
                        }
                    }
                    
                    if(localTables.count != 0) {
                        VStack(spacing: 8) {
                            HStack {
                                Text("На устройстве")
                                    .foregroundColor(Color.cardEnable)
                                    .font(Font.appBold(size: 16))
                                    .frame(height: 36)
                                Spacer()
                            }
                            
                            ForEach(0..<globalTables.count) { index in
                                TimeTableCard(state: .global, name: "Расписание \(index)", code: "\(index)")
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            }
            
            Spacer()
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            localTables = UserDefaults.standard.array(forKey: "localTables")?.map({value in
                return try! JSONDecoder().decode(ServerTimeTable.self, from: (value as! String).data(using: .utf8)!)
            }) ?? []
            
            globalTables = UserDefaults.standard.array(forKey: "globalTables")?.map({value in
                return try! JSONDecoder().decode(ServerTimeTable.self, from: (value as! String).data(using: .utf8)!)
            }) ?? []
        }
        .fullScreenCover(isPresented: $isEditorOpen, onDismiss: nil, content: {
            TimeTableEditor(table: selectedTable)
        })
    }
}

struct MyTimeTablesView_Previews: PreviewProvider {
    static var previews: some View {
        MyTimeTablesView()
    }
}
