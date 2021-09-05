//
//  LoginView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 02.09.2021.
//

import SwiftUI


struct LoginView: View {
    @State var login: String = ""
    @State var password: String = ""
    
    @State var wasRegister = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button("Отмена") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.cardEnable)
                .font(Font.appMedium(size: 20))
                
                Spacer()
                
                Button("Войти") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.cardEnable)
                .font(Font.appMedium(size: 20))
                .animation(.none)
            }
            .padding(16)
            
            if(!wasRegister) {
                HStack {
                    Text("Логин:")
                        .foregroundColor(.cardEnable)
                        .font(Font.appMedium(size: 16))
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                
                TextField("", text: $login, onCommit:  {
                    UIApplication.shared.endEditing()
                })
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appMedium(size: 16))
                    .frame(height:36)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color.cardDisable.opacity(0.5))
                    )
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                HStack {
                    Text("Пароль:")
                        .foregroundColor(.cardEnable)
                        .font(Font.appMedium(size: 16))
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))

                
                TextField("", text: $password, onCommit:  {
                    UIApplication.shared.endEditing()
                })
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appMedium(size: 16))
                    .frame(height:36)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(Color.cardDisable.opacity(0.5))
                    )
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 64, trailing: 16))
                
                Button("Регистрация") {
                    //отправка запроса кода на почту
                    
                    //let passwordHash = hashSHA256(data: password.data(using: .utf8)!)!
                    //login = "\(passwordHash.map { String(format: "%02hhx", $0) }.joined())"
                    //wasRegister = true
                    
                    //login = String(data: try! JSONEncoder().encode(TimeTable.empty), encoding: .utf8)!
                    
//                    let components = URL(string: "http://rustamxaxyk1414.ru.fozzyhost.com/main.php?action=table_q&index=1")!
//                    var request = URLRequest(url: components)
//                    request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
//
//
//                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                        if let data = data {
//                            login = String(decoding: data, as: UTF8.self) + "A"
//                        } else {
//                            login = error!.localizedDescription
//                        }
//                    }
//                    task.resume()
                }
                .padding(16)
                .foregroundColor(Color.cardEnable)
                .font(Font.appMedium(size: 16))
                .background(Color.cardDisable.opacity(0.5))
                .cornerRadius(8)
            } else {
                Text("Для завершения регистрации подтвердите аккаунт перейдя по ссылке, отправленной по почте, которую вы указати.")
                    .foregroundColor(Color.cardEnable.opacity(0.5))
                    .font(Font.appMedium(size: 16))
                    .padding(16)
            }
            
            ScrollView {
                Text(login)
            }
            Spacer()
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
