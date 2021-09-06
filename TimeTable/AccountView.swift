//
//  LoginView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 02.09.2021.
//

import SwiftUI


struct AccountView: View {
    @State var person = user(login: "", session: "")
    @State var isRegistrationOpen: Bool = false
    @State var isLoginingOpen: Bool = false
    @State var isExitOpen = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button("Назад") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.cardEnable)
                .font(Font.appMedium(size: 20))
                
                Spacer()
                
                if(person.session != "") {
                    Button("Выйти") {
                        isExitOpen = true
                    }
                    .foregroundColor(.cardEnable)
                    .font(Font.appMedium(size: 20))
                }
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16))
            
            Spacer()
            
            if(person.session == "") {
                Text("Войдите или зарегистрируйте аккаунт, чтобы иметь возможность создавать и делиться расписаниями.")
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appMedium(size: 16))
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
                    .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Button("Вход") {
                        isLoginingOpen = true
                    }
                    .foregroundColor(.cardEnable)
                    .font(Font.appMedium(size: 16))
                    .padding(12)
                    .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
                    .background(Color.cardDisableLight)
                    .cornerRadius(8)

                    Spacer()
                        .frame(width: 8)
                    
                    Button("Регистрация") {
                        isRegistrationOpen = true
                    }
                    .foregroundColor(.cardEnable)
                    .font(Font.appMedium(size: 16))
                    .padding(12)
                    .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
                    .background(Color.cardDisableLight)
                    .cornerRadius(8)
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            }
             
            else {
                Text(person.login)
                    .padding(EdgeInsets(top: 32, leading: 0, bottom: 0, trailing: 0))
                    .font(Font.appBold(size: 24))
                    .foregroundColor(Color.cardEnable)
                
                List() {
                    Section() {
                        NavigationLink(destination: AccountView()) {
                            Label(title: {
                                Text("Мои расписания")
                                    .foregroundColor(Color.cardEnable)
                                    .font(Font.appMedium(size: 16))
                            }, icon: {
                                
                            })
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .foregroundColor(Color.cardDisableLight)
                        )
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            if(person.session == "") {
                person = try! JSONDecoder().decode(user.self, from: (UserDefaults.standard.string(forKey: "user") ?? String(data: JSONEncoder().encode(user(login: "", session: "")), encoding: .utf8)!).data(using: .utf8)!)
            }
        }
        .actionSheet(isPresented: $isExitOpen) {
            ActionSheet(title: Text("Вы уверены?"), buttons: [
                ActionSheet.Button.destructive(Text("Выйти")) {
                person = user(login: "", session: "")
                UserDefaults.standard.set(String(data: try! JSONEncoder().encode(person), encoding: .utf8), forKey: "user")
                
                isExitOpen = false
            },
                ActionSheet.Button.cancel()
            ])
        }
        .sheet(isPresented: $isRegistrationOpen, onDismiss: {
            
        }, content: { RegistrationView(person: $person,isLoggining: false) } )
        .sheet(isPresented: $isLoginingOpen, onDismiss: {
            
        }, content: { RegistrationView(person: $person,isLoggining: true) } )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
