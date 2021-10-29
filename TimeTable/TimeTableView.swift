//
//  TimeTableView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 01.09.2021.
//

import SwiftUI

struct TimeTableView: View {
    
    @EnvironmentObject var activeTimeTable: TimeTable
    
    @State var date: Date = Date(timeIntervalSinceNow: 0)
    @State var selectedDay: Int = Date(timeIntervalSinceNow: 0).weekDay - 1
    @State var nowLesson: CardState = .wait
    @State var isSelectMenu = false
    
    @State var errorText: String = ""
    @State var isErrorShow: Bool = false
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {

                HStack {
                    Button(activeTimeTable.isEmpty ? "Выбрать" : activeTimeTable.name) {
                        isSelectMenu = true
                    }
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appBold(size: 24))
                    
                    Spacer()
                    
                    if(!activeTimeTable.isEmpty) {
                        Button("Обновить") {
                            postRequest(action: "get_timetable", values: ["id":"\(activeTimeTable.tableID!)"], onSucsess: { data, response, error in
                                if let data = data {
                                    let json = String(data: data, encoding: .utf8)!
                                    
                                    let request = try! JSONDecoder().decode(loadTableRequest.self, from: json.data(using: .utf8)!)
                                    
                                    if(request.error.code == 0) {
                                        let json = toDictionary(data: data)!
                                        
                                        let tableData = try! JSONSerialization.data(withJSONObject: (json["timetable"] as! [String: Any])["json"] as! [String: Any], options: .prettyPrinted)

                                        let loadTable = try! JSONDecoder().decode(TimeTable.self, from: tableData)
                                        loadTable.tableID = (json["timetable"] as! [String: Any])["id"] as? Int
                                        
                                        DispatchQueue.main.async {
                                            activeTimeTable.setValues(table: loadTable)
                                            UserDefaults.standard.set(String(data: try! JSONEncoder().encode(activeTimeTable), encoding: .utf8)!, forKey: "timetable")
                                            UserDefaults.standard.synchronize()
                                        }
                                    } else {
                                        errorText = request.error.message
                                        isErrorShow = true
                                    }
                                }
                            })
                        }
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appMedium(size: 16))
                    }
                }
                .frame(height: 36)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    
                TableView(selectedDay: $selectedDay, activeTimeTable: activeTimeTable, date: $date, isEditing: false)
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
            
            if(activeTimeTable.tableID ?? -1 >= 0) {
                if(date.timeIntervalSince1970 - UserDefaults.standard.double(forKey: "lastUpdate") > 1000 * 60 * 10) {
                    UserDefaults.standard.set(date.timeIntervalSince1970, forKey: "lastUpdate")
                    
                    postRequest(action: "get_timetable", values: ["id":"\(activeTimeTable.tableID!)"], onSucsess: { data, response, error in
                        if let data = data {
                            let json = String(data: data, encoding: .utf8)!
                            
                            let request = try! JSONDecoder().decode(loadTableRequest.self, from: json.data(using: .utf8)!)
                            
                            if(request.error.code == 0) {
                                let json = toDictionary(data: data)!
                                
                                let tableData = try! JSONSerialization.data(withJSONObject: (json["timetable"] as! [String: Any])["json"] as! [String: Any], options: .prettyPrinted)

                                let loadTable = try! JSONDecoder().decode(TimeTable.self, from: tableData)
                                loadTable.tableID = (json["timetable"] as! [String: Any])["id"] as? Int
                                
                                DispatchQueue.main.async {
                                    activeTimeTable.setValues(table: loadTable)
                                    UserDefaults.standard.set(String(data: try! JSONEncoder().encode(activeTimeTable), encoding: .utf8)!, forKey: "timetable")
                                    UserDefaults.standard.synchronize()
                                }
                            }
                        }
                    })
                }
            }
        }
        .sheet(isPresented: $isSelectMenu, content: {
            LoadTimeTableView(timeTable: activeTimeTable)
        })
        .animation(.none)
        .background(Color.appBackground.ignoresSafeArea())
        .alert(isPresented: $isErrorShow) {
            Alert(title: Text("Ошибка"), message: Text(errorText), dismissButton: .cancel())
        }

    }
}

struct TimeTableView_Previews: PreviewProvider {
    
    @State static var timeTable: TimeTable = TimeTable.empty
    
    static var previews: some View {
        TimeTableView()
            .environmentObject(timeTable)
    }
}
