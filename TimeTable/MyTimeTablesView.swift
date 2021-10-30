//
//  MyTimeTablesView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 08.09.2021.
//

import SwiftUI


class SavedTables: ObservableObject {
    @Published var globalTables: [globalTableInfo] = []
    @Published var localTables: [TimeTable] = []
    
    @Published var globalSavedTables: [savedTableInfo] = []
    
    @Published var selectedType: TimeTableState = .local
    @Published var selectedTable: Int = 0
    @Published var selectedID: Int = -1
    
    func isLoad(id: String) -> Bool {
        return globalSavedTables.contains(where: {val in "\(val.id)" == id})
    }
    
    func saveArray(state: TimeTableState) {
        if state == .local {
            UserDefaults.standard.set(localTables.map({ val in
                return String(data: try! JSONEncoder().encode(val), encoding: .utf8)
            }), forKey: "localTables")
        } else {
            UserDefaults.standard.set(globalTables.map({ val in
                return String(data: try! JSONEncoder().encode(val), encoding: .utf8)
            }), forKey: "globalTables")
            
            saveSavedTables()
        }
        UserDefaults.standard.synchronize()
    }
    
    func clearSaves() {
        globalSavedTables.removeAll(where: {val in
            !globalTables.contains(where: {value in
                Int(value.tableID)! == val.id
            })
        })
        saveSavedTables()
    }
    
    func saveSavedTables() {
        UserDefaults.standard.set(globalSavedTables.map({ val in
            return String(data: try! JSONEncoder().encode(val), encoding: .utf8)
        }), forKey: "globalSaved")
    }
}

struct savedTableInfo: Codable {
    var id: Int
    var loaded: TimeTable
    var table: TimeTable
    
    var isChange: Bool {
        get {
            return loaded != table
        }
    }
}

struct MyTablesList: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var activeTimeTable: TimeTable

    @ObservedObject var tables: SavedTables
    @Binding var isEditorOpen: Bool
    @Binding var user: user
    @Binding var isErrorShow: Bool
    @Binding var errorMessage: String
    @State var code: String = ""
    @State var isSelectedTable: Bool = false
    @State var isSelectedLocalTable: Bool = false
    @StateObject var selectedLocalTable: TimeTable = .empty

    var body: some View {
        ScrollView() {
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    HStack {
                        Text("Опубликованые")
                            .foregroundColor(Color.cardEnableLight)
                            .font(Font.appBold(size: 16))
                            .frame(height: 36)
                        
                        Spacer()
                        
                        Button(action: {
                            postRequest(action: "get_my_timetables", values: ["login":"\(user.login)", "session":"\(user.session)"], onSucsess: { data, responce, error in
                                if let data = data {
                                    let result = try! JSONDecoder().decode(loadTableRequest.self, from: data)

                                    if(result.error.code != 0) {
                                        errorMessage = result.error.message
                                        isErrorShow = true
                                    } else {
                                        let json = toDictionary(data: data)!
                                        user.session = json["session"] as! String
                                        let tableData = try! JSONSerialization.data(withJSONObject: json["timeTables"] as! [[String: Any]], options: .prettyPrinted)
                                        let tbls :[globalTableInfo] = try! JSONDecoder().decode([globalTableInfo].self, from: tableData)
                                         
                                        DispatchQueue.main.async {
                                            tables.globalTables = tbls
                                            tables.saveArray(state: .global)
                                            tables.objectWillChange.send()
                                        }
                                    }
                                } else {
                                    errorMessage = "Не удалось отправить запрос, проверьте соединение с интернетом и попробуйте снова"
                                    isErrorShow = true
                                }
                            })
                        }, label: {
                            Text("Обновить")
                                .foregroundColor(Color.cardEnable)
                                .font(Font.appBold(size: 16))
                        })
                    }
                    
                    ForEach($tables.globalTables, id: \.id) { table in
                        let isLoad = tables.isLoad(id: table.tableID.wrappedValue)
                        let isChange = isLoad ? tables.globalSavedTables.first(where: {t in t.id == Int(table.tableID.wrappedValue)!})!.isChange : false
                        
                        TimeTableCard(state: .constant(isChange ? .changed : .global), name: isChange ? $tables.globalSavedTables[tables.globalSavedTables.firstIndex(where: {t in
                            t.id == Int(table.tableID.wrappedValue)!
                        })!].table.name : table.name, code: table.invite_code, onDelete: {
                            postRequest(action: "delete_timetable", values: ["login":user.login, "session": "\(user.session)", "id":table.tableID.wrappedValue], onSucsess: {data, response, error in

                                if let data = data {
                                    let result = try! JSONDecoder().decode(loadTableRequest.self, from: data)

                                    if(result.error.code != 0) {
                                        errorMessage = result.error.message
                                        isErrorShow = true
                                    } else {
                                        DispatchQueue.main.async {
                                            tables.globalSavedTables.removeAll(where: {val in
                                                val.id == Int(table.tableID.wrappedValue)!
                                            })
                                            tables.globalTables.removeAll(where: {val in val.tableID == table.tableID.wrappedValue})
                                            tables.saveArray(state: .global)
                                            tables.objectWillChange.send()
                                        }
                                    }
                                } else {
                                    errorMessage = "Не удалось отправить запрос, проверьте соединение с интернетом и попробуйте снова"
                                    isErrorShow = true
                                }
                            })
                        }, onShare: {
                            postRequest(action: "update_timetable", values: [
                                "login":user.login,
                                "session": user.session,
                                "id": table.tableID.wrappedValue,
                                "json": String(data: try! JSONEncoder().encode(tables.globalSavedTables[tables.globalSavedTables.firstIndex(where: {val in val.id == Int(table.tableID.wrappedValue)!})!].table), encoding: .utf8)!
                            ], onSucsess: {data, sresponse, error in
                                if let data = data {
                                    let result = try! JSONDecoder().decode(loadTableRequest.self, from: data)

                                    if(result.error.code == 0) {
                                        DispatchQueue.main.async {
                                            tables.globalTables[tables.globalTables.firstIndex(where: {t in
                                                t.tableID == table.tableID.wrappedValue
                                            })!].name = tables.globalSavedTables.first(where: {val in
                                                val.id == Int(table.tableID.wrappedValue)!
                                            })!.table.name
                                            
                                            tables.globalSavedTables.removeAll(where: {val in
                                                val.id == Int(table.tableID.wrappedValue)!
                                            })

                                            tables.clearSaves()
                                            
                                            tables.saveArray(state: .global)
                                            tables.objectWillChange.send()
                                        }
                                    } else {
                                        errorMessage = result.error.message
                                        isErrorShow = true
                                    }
                                } else {
                                    errorMessage = "Не удалось отправить запрос, проверьте соединение с интернетом и попробуйте снова"
                                    isErrorShow = true
                                }
                            })
                        }, onSet: {
                            code = table.wrappedValue.invite_code!
                            isSelectedTable = true
                            
                        }, onChangesDelete: {
                            tables.globalSavedTables.removeAll(where: {val in
                                val.id == Int(table.tableID.wrappedValue)!
                            })

                            tables.clearSaves()
                            
                            tables.saveArray(state: .global)
                            tables.objectWillChange.send()
                        })
                            .onTapGesture {
                                postRequest(action: "get_timetable", values: ["id":table.tableID.wrappedValue], onSucsess: {data, response, error in
                                    if let data = data {
                                        
                                        let request = try! JSONDecoder().decode(loadTableRequest.self, from: data)
                                        
                                        if(request.error.code == 0) {
                                            let json = toDictionary(data: data)!

                                            let tableData = try! JSONSerialization.data(withJSONObject: (json["timetable"] as! [String: Any])["json"] as! [String: Any], options: .prettyPrinted)

                                            let loadTable = try! JSONDecoder().decode(TimeTable.self, from: tableData)
                                            let loadTable2 = try! JSONDecoder().decode(TimeTable.self, from: tableData)
                                            loadTable.tableID = (json["timetable"] as! [String: Any])["id"] as? Int
                                            loadTable2.tableID = (json["timetable"] as! [String: Any])["id"] as? Int
                                            loadTable.invite_code = table.invite_code.wrappedValue
                                            loadTable2.invite_code = table.invite_code.wrappedValue

                                            DispatchQueue.main.async {
                                                tables.globalSavedTables.removeAll { savedTableInfo in
                                                    savedTableInfo.id == loadTable.tableID
                                                }
                                                tables.globalSavedTables.append(savedTableInfo(id: loadTable.tableID!, loaded: loadTable, table: loadTable2))
                                                tables.saveArray(state: .global)

                                                tables.selectedType = .global
                                                tables.selectedID = Int(table.tableID.wrappedValue)!
                                                tables.selectedTable = tables.globalTables.firstIndex(where: {t in
                                                    t.tableID == table.tableID.wrappedValue
                                                })!
                                                isEditorOpen = true
                                            }
                                        } else {
                                            errorMessage = request.error.message
                                            isErrorShow = true
                                        }
                                    }
                                })
                            }
                    }
                
                    if(tables.globalTables.count == 0)  {
                        Text("Расписаний нет")
                            .padding(16)
                            .foregroundColor(Color.cardEnableLight)
                    }
                }
            
                VStack(spacing: 8) {
                    HStack {
                        Text("На устройстве")
                            .foregroundColor(Color.cardEnableLight)
                            .font(Font.appBold(size: 16))
                            .frame(height: 36)
                        Spacer()
                    }
                    ForEach($tables.localTables, id: \.id) { table in
                        TimeTableCard(state: .constant(.local), name: table.name, code: .constant(""), onDelete: {
                            tables.localTables.removeAll(where: {t in t === table.wrappedValue})
                            tables.saveArray(state: .local)
                        }, onShare: {
                            postRequest(action: "create_timetable", values: ["login":user.login, "session": user.session, "json": String(data: try! JSONEncoder().encode(table.wrappedValue), encoding: .utf8)!], onSucsess: {data, response, error in

                                if let data = data {
                                    let result = try! JSONDecoder().decode(loadTableRequest.self, from: data)
                                    let json = toDictionary(data: data)!
                                                                            
                                    if(result.error.code != 0) {
                                        errorMessage = result.error.message
                                        isErrorShow = true
                                    } else {
                                        DispatchQueue.main.async {
                                            tables.globalTables.append(globalTableInfo(name: table.name.wrappedValue, tableID: json["id"] as! String, invite_code: json["invite_code"] as? String))
                                            
                                            tables.localTables.removeAll(where: {t in t === table.wrappedValue})
                                        
                                            tables.saveArray(state: .global)
                                            tables.saveArray(state: .local)
                                            tables.objectWillChange.send()
                                        }

                                    }
                                } else {
                                    errorMessage = "Не удалось отправить запрос, проверьте соединение с интернетом и попробуйте снова"
                                    isErrorShow = true
                                }
                            })
                        }, onSet: {
                            
                            selectedLocalTable.setValues(table: table.wrappedValue)
                                                        
                            isSelectedLocalTable = true
                            
                        })
                            .onTapGesture {
                                tables.selectedID = table.wrappedValue.tableID!
                                tables.selectedType = .local
                                tables.selectedTable = tables.localTables.firstIndex(where: {t in t === table.wrappedValue})!
                                isEditorOpen = true
                            }
                    }
                    
                    if(tables.localTables.count == 0)  {
                        Text("Расписаний нет")
                            .padding(16)
                            .foregroundColor(Color.cardEnableLight)
                    }
                }
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        }
        .sheet(isPresented: $isSelectedTable) {
            TablePreviewView(code: $code, timeTablePreview: TimeTable.empty)
        }
        
        .sheet(isPresented: $isSelectedLocalTable) {
            TablePreviewView(code: Binding.constant(""), timeTablePreview: selectedLocalTable)
        }
    }
}

func getNewLocalID() -> Int {
    let strings = UserDefaults.standard.array(forKey: "localTables") as! [String]
    
    var tables: [TimeTable] = []
    
    for i in strings {
        tables.append(try! JSONDecoder().decode(TimeTable.self, from: i.data(using: .utf8)!))
    }
    
    var newID = -1
    newID = -((UserDefaults.standard.integer(forKey: "localID") + 1) % 10000)
    UserDefaults.standard.set(-newID, forKey: "localID")
    
    print(newID)
    
    return newID
}

struct MyTimeTablesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var activeTimeTable: TimeTable

    @StateObject var tables: SavedTables = SavedTables()
    @Binding var user: user
        
    @State var isErrorShow: Bool = false
    @State var errorMessage: String = ""
    
    @State var isEditorOpen: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            NavigationLink(destination: TimeTableEditor(tables: tables), isActive: $isEditorOpen, label: {})
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)

            HStack {
                Button("Назад") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.cardEnable)
                .font(Font.appMedium(size: 20))
                .frame(height: 42)
                
                Spacer()
                
                Button("Добавить") {
                    let table = TimeTable.empty
                    table.name = "Без имени"
                    table.tableID = getNewLocalID()
                                        
                    tables.localTables.append(table)
                    tables.selectedType = .local
                    tables.selectedTable = tables.localTables.count - 1
                    isEditorOpen = true
                    
                    UserDefaults.standard.set(tables.localTables.map({ val in
                        return String(data: try! JSONEncoder().encode(val), encoding: .utf8)
                    }), forKey: "localTables")
                    
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

            
            MyTablesList(tables: tables, isEditorOpen: $isEditorOpen, user: $user, isErrorShow: $isErrorShow, errorMessage: $errorMessage)
            
            Spacer()
        }

        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            tables.localTables = UserDefaults.standard.array(forKey: "localTables")?.map({value in
                return try! JSONDecoder().decode(TimeTable.self, from: (value as! String).data(using: .utf8)!)
            }) ?? []
            
            tables.globalTables = UserDefaults.standard.array(forKey: "globalTables")?.map({value in
                return try! JSONDecoder().decode(globalTableInfo.self, from: (value as! String).data(using: .utf8)!)
            }) ?? []
            
            tables.globalSavedTables = UserDefaults.standard.array(forKey: "globalSaved")?.map({value in
                return try! JSONDecoder().decode(savedTableInfo.self, from: (value as! String).data(using: .utf8)!)
            }) ?? []
            
            postRequest(action: "get_my_timetables", values: ["login":"\(user.login)", "session":"\(user.session)"], onSucsess: { data, responce, error in
                if let data = data {
                    let json = toDictionary(data: data)!
                    user.session = json["session"] as! String
                    let tableData = try! JSONSerialization.data(withJSONObject: json["timeTables"] as! [[String: Any]], options: .prettyPrinted)

                    let tbls :[globalTableInfo] = try! JSONDecoder().decode([globalTableInfo].self, from: tableData)

                    DispatchQueue.main.async {
                        tables.globalTables = tbls
                        tables.saveArray(state: .global)
                    }
                }
            })
        }
        .alert(isPresented: $isErrorShow, content: {
            Alert(title: Text("Ошибка"),
                  message: Text(errorMessage),
                  dismissButton: Alert.Button.default(Text("Ок")))
        })
    }
}

struct MyTimeTablesView_Previews: PreviewProvider {
    static var previews: some View {
        MyTimeTablesView(user: .constant(user.empty))
    }
}
