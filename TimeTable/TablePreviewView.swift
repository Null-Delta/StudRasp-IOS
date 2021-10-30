//
//  TablePreviewView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 14.09.2021.
//

import SwiftUI

struct TablePreviewView: View {
    @Binding var code: String
    
    @StateObject var timeTablePreview: TimeTable
    @EnvironmentObject var activeTimeTable: TimeTable
    
    @State var errorMessage: String = ""
    @State var isErrorShow: Bool = false
    
    @State var selectedDay = 0
    @State var date = Date()
    
    @State var isFileAdding: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                if(!timeTablePreview.isEmpty) {
                    HStack {
                        Button("Отмена") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appMedium(size: 20))
                        
                        Spacer()
                        
                        Button("Использовать") {
                            if(isFileAdding) {
                                //TODO: add file
                                timeTablePreview.tableID = getNewLocalID()
                                var tables = UserDefaults.standard.array(forKey: "localTables") as! [String]
                                tables.append(String(data: try! JSONEncoder().encode(timeTablePreview), encoding: .utf8)!)
                                UserDefaults.standard.set(tables, forKey: "localTables")
                            }
                            
                            activeTimeTable.setValues(table: timeTablePreview)
                                                            
                            UserDefaults.standard.set(String(data: try! JSONEncoder().encode(activeTimeTable), encoding: .utf8)!, forKey: "timetable")
                            UserDefaults.standard.synchronize()
                            
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appMedium(size: 20))
                    }
                    .padding(16)
                    
                    Text(timeTablePreview.name)
                        .frame(maxWidth: .infinity, minHeight: 42, alignment: .leading)
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appBold(size: 24))
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                    
                    TableView(selectedDay: $selectedDay, activeTimeTable: timeTablePreview, date: $date, isEditing: false)
                    
                } else {
                    Text("Загрузка")
                        .foregroundColor(Color.cardEnableLight)
                        .font(Font.appMedium(size: 20))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .onAppear {
                print("here \(timeTablePreview.name)")

                if(timeTablePreview.isEmpty) {
                    postRequest(action: "get_timetable_by_invite_code", values: ["invite_code":code], onSucsess: {data, response, error in
                        if let data = data {
                            
                            let request = try! JSONDecoder().decode(loadTableRequest.self, from: data)
                            
                            if(request.error.code == 0) {
                                let json = toDictionary(data: data)!
                                
                                let tableData = try! JSONSerialization.data(withJSONObject: (json["timetable"] as! [String: Any])["json"] as! [String: Any], options: .prettyPrinted)

                                let loadTable = try! JSONDecoder().decode(TimeTable.self, from: tableData)
                                loadTable.tableID = (json["timetable"] as! [String: Any])["id"] as? Int
                                
                                DispatchQueue.main.async {
                                    timeTablePreview.setValues(table: loadTable)
                                }
                                                                
                            } else {
                                errorMessage = request.error.message
                                isErrorShow = true
                            }
                        } else {
                            errorMessage = "Не удалось отправить запрос, проверьте соединение с интернетом и попробуйте снова"
                            isErrorShow = true
                        }
                    })
                }
            }
            .alert(isPresented: $isErrorShow) {
                Alert(title: Text("Ошибка"), message: Text(errorMessage), dismissButton: .cancel() {
                    presentationMode.wrappedValue.dismiss()
                })
            }
            
            if(!timeTablePreview.isEmpty) {
                WeekView(date: $date, selectedDay: $selectedDay, isInSheet: true)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .onOpenURL(perform: {url in
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct TablePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        TablePreviewView(code: .constant("0000"), timeTablePreview: TimeTable.empty)
    }
}
