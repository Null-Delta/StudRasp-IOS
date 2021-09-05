//
//  RegistrationView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 05.09.2021.
//

import SwiftUI

struct RegistrationView: View {
    @State var login: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var code: String = ""
    
    @State var errorText: String = ""
    @State var isShowError: Bool = false
    
    @State var wasRegistered: Bool = false
    
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
                    if(!wasRegistered) {
                        
                        let components = URL(string: "https://\(mainDomain)/main.php?action=registration&login=\(login)&email=\(email)&password=\(password.sha256())")!

                        var request = URLRequest(url: components)
                        request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
                        request.timeoutInterval = 5

                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            if let data = data {
                                print(String(data: data, encoding: .utf8))
                                
                                let request = try! JSONDecoder().decode(loadTableRequest.self, from: data)

                                if(request.error.code == 0) {
                                    wasRegistered = true
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

                    }
                }, label:  {
                    Text(wasRegistered ? "Подтверждение" : "Регистрация")
                        .foregroundColor(canRegistration() ? .cardEnable : .cardEnableLight)
                })
                .disabled(!canRegistration())
                .font(Font.appMedium(size: 20))
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0))
            
            
            if(!wasRegistered) {
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
                
                HStack {
                    Text("Пароль")
                        .foregroundColor(.cardEnable)
                        .font(Font.appMedium(size: 16))
                    
                    Spacer()
                }
                
                TextField("", text: $password)
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
            }
            else {
                HStack {
                    Text("Код")
                        .foregroundColor(.cardEnable)
                        .font(Font.appMedium(size: 16))
                    
                    Spacer()
                }
                
                TextField("", text: $code)
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
            }
                
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .background(Color.appBackground.ignoresSafeArea())
        .alert(isPresented: $isShowError) {
            Alert(title: Text("Ошибка"), message: Text(errorText), dismissButton: .cancel())
        }
    }
    
    func checkemail(val: String) -> Bool {
        let redex = try! NSRegularExpression(pattern: #"([a-z0-9.]){1,}@([a-z0-9.]){1,}\.([a-z0-9.]){2,}"#, options: .caseInsensitive)
        return NSRegularExpression.numberOfMatches(redex)(in: val, options: .anchored, range: NSRange(location: 0, length: val.count)) != 0
    }
    
    func checkPassword(val: String) -> Bool {
        let redex = try! NSRegularExpression(pattern: #"(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[\.,()!@#$%^&*])([a-zA-Z0-9\.,()!@#$%^&*]){8}"#)
        return NSRegularExpression.numberOfMatches(redex)(in: val, options: .anchored, range: NSRange(location: 0, length: val.count)) != 0
    }
    
    func canRegistration() -> Bool {
        if(!wasRegistered) {
            return checkValues() == "" && login.count != 0 && password.count != 0 && email.count != 0
        } else {
            return code.count > 0
        }
    }
    
    func checkValues() -> String {
        if login.count > 0 && login.count < 3 {
            return "Логин должен быть длиной больше 2х символов"
        }
        else if email.count > 0 && !checkemail(val: email) {
            return "Введена некорректная почта"
        }
        else if password.count > 0 && !checkPassword(val: password) {
            return "Введен некорректный пароль. Пароль должен быть длиной минимум 8 символов, сожержать хотябы одно число, заглавную, прописную буквы и спец. символ: \n.,()!@#$%^&* "
        }
        return ""
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
