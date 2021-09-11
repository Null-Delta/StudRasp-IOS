//
//  LoadTimeTableView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 02.09.2021.
//

import SwiftUI


struct LoadTimeTableView: View {
    @State var code: String = ""
    @Binding var timeTable: ServerTimeTable
    
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
                        
                        .keyboardType(.numberPad)
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
                    let url = URL(string: "https://\(mainDomain)/main.php")!
                    
                    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                    
                    components.queryItems = [
                        URLQueryItem(name: "action", value: "get_timetable"),
                        URLQueryItem(name: "index", value: code)
                    ]
                    
                    var request = URLRequest(url: url)
                    
                    request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
                    request.httpMethod = "POST"
                    request.httpBody = Data(components.url!.query!.utf8)
                    request.timeoutInterval = 5
    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        isSearching = false
                        if let data = data {
                            let json = String(data: data, encoding: .utf8)!
                            print(json)
                            
                            let request = try! JSONDecoder().decode(loadTableRequest.self, from: json.data(using: .utf8)!)
                            
                            if(request.error.code == 0) {
                                timeTable = request.timetable!
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
                    }
                    
                    task.resume()
                    
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
    }
}

struct LoadTimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        LoadTimeTableView(timeTable: .constant(ServerTimeTable(id: -1, info: TimeTable.empty)))
    }
}
