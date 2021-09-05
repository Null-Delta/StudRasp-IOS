//
//  LoginView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 02.09.2021.
//

import SwiftUI


struct AccountView: View {
    @State var person = user(login: "", session: -2)
    @State var isRegistrationOpen: Bool = false
    
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
                
                if(person.session >= 0) {
                    Button("Выйти") {
                        
                    }
                    .foregroundColor(.cardEnable)
                    .font(Font.appMedium(size: 20))
                }
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16))
            
            Spacer()
            
            if(person.session < 0) {
                Text("Вы еще не вошли в аккаунт.")
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appMedium(size: 16))
                    .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
                    .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Button("Вход") {
                        presentationMode.wrappedValue.dismiss()
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
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            if(person.session == -2) {
                person = try! JSONDecoder().decode(user.self, from: (UserDefaults.standard.string(forKey: "user") ?? String(data: JSONEncoder().encode(user(login: "", session: -1)), encoding: .utf8)!).data(using: .utf8)!)
            }
        }
        .sheet(isPresented: $isRegistrationOpen, onDismiss: {
            
        }, content: { RegistrationView() } )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
