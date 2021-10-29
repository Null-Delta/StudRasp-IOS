//
//  RegistrationView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 05.09.2021.
//

import SwiftUI

struct RegistrationView: View {
    @Binding var person: user
    @State var isLoggining: Bool

    @State var login: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var code: String = ""
    
    @State var errorText: String = ""
    @State var isShowError: Bool = false
    
        
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
                
                Button(action: {
                    if(isLoggining) {
                        let url = URL(string: "https://\(mainDomain)/main.php")!
                        
                        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                        
                        components.queryItems = [
                            URLQueryItem(name: "action", value: "authorization"),
                            URLQueryItem(name: "login", value: login),
                            URLQueryItem(name: "password", value: password),
                        ]
                        
                        var request = URLRequest(url: url)
                        
                        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
                        request.httpMethod = "POST"
                        request.httpBody = Data(components.url!.query!.utf8)
                        request.timeoutInterval = 5
                        
                        
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            if let data = data {
                                let request = try! JSONDecoder().decode(loadTableRequest.self, from: data)

                                if(request.error.code == 0) {
                                    
                                    let newUser = user(login: request.login!, session: request.session!, email: request.email!)
                                    UserDefaults.standard.set(String(data: try! JSONEncoder().encode(newUser), encoding: .utf8), forKey: "user")
                                    person = newUser
                                    
                                    presentationMode.wrappedValue.dismiss()
                                    
                                } else {
                                    errorText = request.error.message
                                    isShowError = true
                                }
                            } else {
                                errorText = "Не удалось отправить запрос, проверьте соединение с интернетом и попробуйте снова"
                                isShowError = true
                            }
                        }

                        task.resume()
                    } else {
                        let url = URL(string: "https://\(mainDomain)/main.php")!
                        
                        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                        
                        components.queryItems = [
                            URLQueryItem(name: "action", value: "registration"),
                            URLQueryItem(name: "login", value: login),
                            URLQueryItem(name: "password", value: password),
                            URLQueryItem(name: "email", value: email)
                        ]
                        
                        var request = URLRequest(url: url)
                        
                        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
                        request.httpMethod = "POST"
                        request.httpBody = Data(components.url!.query!.utf8)
                        request.timeoutInterval = 5
                                                
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            if let data = data {
                                

                                let request = try! JSONDecoder().decode(loadTableRequest.self, from: data)

                                if(request.error.code == 0) {
                                    
                                    let newUser = user(login: login, session: request.session!, email: email)
                                    UserDefaults.standard.set(String(data: try! JSONEncoder().encode(newUser), encoding: .utf8), forKey: "user")
                                    person = newUser
                                    
                                    presentationMode.wrappedValue.dismiss()
                                    
                                } else {
                                    errorText = request.error.message
                                    isShowError = true
                                }
                            } else {
                                errorText = "Не удалось отправить запрос, проверьте соединение с интернетом и попробуйте снова"
                                isShowError = true
                            }
                        }

                        task.resume()
                    }
                }, label:  {
                    Text(isLoggining ? "Вход" : "Регистрация")
                        .foregroundColor(canRegistration() ? .cardEnable : .cardEnableLight)
                })
                .disabled(!canRegistration())
                .font(Font.appMedium(size: 20))
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0))
            
            
                HStack {
                    Text("Логин")
                        .foregroundColor(.cardEnable)
                        .font(Font.appMedium(size: 16))
                    
                    Spacer()
                }
                
                TextField("", text: $login)
                    .frame(height: 36, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(Color.cardDisableLight)
                    )
                    .foregroundColor(.cardEnable)
                    .font(Font.appMedium(size: 20))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))

            if(!isLoggining) {
                HStack {
                    Text("Почта")
                        .foregroundColor(.cardEnable)
                        .font(Font.appMedium(size: 16))
                    
                    Spacer()
                }
                
                TextField("", text: $email)
                    .frame(height: 36, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(Color.cardDisableLight)
                    )
                    .foregroundColor(.cardEnable)
                    .font(Font.appMedium(size: 20))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                
            }
                HStack {
                    Text("Пароль")
                        .foregroundColor(.cardEnable)
                        .font(Font.appMedium(size: 16))
                    
                    Spacer()
                }
                
                SecureField("", text: $password)
                    .frame(height: 36, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(Color.cardDisableLight)
                    )
                    .foregroundColor(.cardEnable)
                    .font(Font.appMedium(size: 20))
                    .textContentType(.password)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))

                Text(checkValues())
                    .font(Font.appMedium(size: 16))
                    .foregroundColor(Color.red)
                
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .background(Color.appBackground.ignoresSafeArea())
        .alert(isPresented: $isShowError) {
            Alert(title: Text("Ошибка"), message: Text(errorText), dismissButton: .cancel())
        }
        .onOpenURL(perform: {url in
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    func checkemail(val: String) -> Bool {
        let redex = try! NSRegularExpression(pattern: #"([a-z0-9.]){1,}@([a-z0-9.]){1,}\.([a-z0-9.]){2,}"#, options: .caseInsensitive)
        return NSRegularExpression.numberOfMatches(redex)(in: val, options: .anchored, range: NSRange(location: 0, length: val.count)) != 0
    }
    
    func checkPassword(val: String) -> Bool {
        let redex = try! NSRegularExpression(pattern: #"(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])([a-zA-Z0-9\.,()!@#$%^&*]){8}"#)
        return NSRegularExpression.numberOfMatches(redex)(in: val, options: .anchored, range: NSRange(location: 0, length: val.count)) != 0
    }
    
    func canRegistration() -> Bool {
        return checkValues() == "" && login.count != 0 && password.count != 0 && (isLoggining ? true : email.count != 0)
    }
    
    func checkValues() -> String {
        if login.count > 0 && login.count < 3 {
            return "Логин должен быть длиной больше 2х символов"
        }
        else if email.count > 0 && !checkemail(val: email) {
            return "Введена некорректная почта"
        }
        else if password.count > 0 && !checkPassword(val: password) {
            return "Введен некорректный пароль. Пароль должен быть длиной минимум 8 символов, сожержать хотябы одно число, заглавную и прописную буквы"
        }
        return ""
    }
}

struct RegistrationView_Previews: PreviewProvider {
    @State static var person = user(login: "", session: "")
    static var previews: some View {
        RegistrationView(person: $person, isLoggining: true)
    }
}
