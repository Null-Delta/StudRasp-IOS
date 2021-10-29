//
//  LoadTimeTableView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 02.09.2021.
//

import SwiftUI

struct LoadTimeTableView: View {
    @State var code: String = ""
    @ObservedObject var timeTable: TimeTable
    
    @State var errorText: String = ""
    @State var isShowError: Bool = false
    @State var isSearching: Bool = false
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                
                ZStack {
                    TextField("", text: $code, onEditingChanged: { isEdit in
                        
                    })
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appMedium(size: 20))
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color.cardDisableLight)
                                .frame(height: 36)
                        )
                }
                
                Button(action: {
                    isSearching = true
                    
                    postRequest(action: "get_timetable_by_invite_code", values: ["invite_code":"\(code)"], onSucsess: { data, response, error in
                        isSearching = false
                        if let data = data {
                            let json = String(data: data, encoding: .utf8)!
                            
                            let request = try! JSONDecoder().decode(loadTableRequest.self, from: json.data(using: .utf8)!)
                            
                            if(request.error.code == 0) {
                                let json = toDictionary(data: data)!
                                
                                let tableData = try! JSONSerialization.data(withJSONObject: (json["timetable"] as! [String: Any])["json"] as! [String: Any], options: .prettyPrinted)

                                let loadTable = try! JSONDecoder().decode(TimeTable.self, from: tableData)
                                loadTable.tableID = (json["timetable"] as! [String: Any])["id"] as? Int
                                
                                DispatchQueue.main.async {
                                    timeTable.setValues(table: loadTable)
                                }
                                                                
                                UserDefaults.standard.set(String(data: try! JSONEncoder().encode(timeTable), encoding: .utf8)!, forKey: "timetable")
                                UserDefaults.standard.synchronize()

                                presentationMode.wrappedValue.dismiss()
                            } else {
                                errorText = request.error.message
                                isShowError = true
                            }
                        } else {
                            errorText = "Не удалось отправить запрос, проверьте соединение с интернетом и попробуйте снова"
                            isShowError = true
                            //login = error!.localizedDescription
                        }
                    })
                    
                }, label: {
                        Text("Добавить")
                            .font(Font.appMedium(size: 20))
                            .foregroundColor(code.count == 0 ? Color.cardEnableLight : Color.cardEnable)
                    }
                )
                .padding(8)
                //.accentColor(Color.cardEnable)
            
                .disabled(code.count == 0 || isSearching)
                

                .alert(isPresented: $isShowError) {
                    Alert(title: Text("Ошибка"), message: Text(errorText), dismissButton: .cancel())
                }
            }
            .frame(height: 36)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
            Spacer()
        }
        .background(Color.appBackground.ignoresSafeArea())
        .onOpenURL(perform: {url in
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct LoadTimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        LoadTimeTableView(timeTable: TimeTable.empty)
    }
}
