//
//  SettingsMenu.swift
//  TimeTable
//
//  Created by Рустам Хахук on 02.09.2021.
//

import SwiftUI

struct SettingsMenu: View {
    @State var isLoginMenu: Bool = false
    @State var person: user = user.empty

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                
                Button(person.isEmpty ? "Войти" : "Выйти") {
                    isLoginMenu = true
                }
                .foregroundColor(.cardEnable)
                .font(Font.appMedium(size: 20))
            }
            .frame(height: 42)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            
            
            Text(person.login)
                .foregroundColor(.cardEnable)
                .font(Font.appMedium(size: 20))
            
            
            Spacer()
            
            
            Button("О Приложении") {
            }
            .foregroundColor(.cardEnable)
            .font(Font.appMedium(size: 20))
            .padding(8)
            .cornerRadius(8)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
        .background(Color.appBackground.ignoresSafeArea())
        
        .sheet(isPresented: $isLoginMenu, content: {
            LoginView()
        })
    }
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu(isLoginMenu: false)
    }
}
