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
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 8) {
                    Image(uiImage: UIImage(named: "mainicon")!)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 128, height: 128, alignment: .center)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    Text("StudRasp")
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appBold(size: 24))
                    
                    Text("v1.0 (beta)")
                        .foregroundColor(Color.cardEnableLight)
                        .font(Font.appBold(size: 16))
                    
                    List {
                        Section() {
                            NavigationLink(destination: AccountView()) {
                                Label(title: {
                                    Text("Аккаунт")
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
                        
                        Section() {
                            NavigationLink(destination: AccountView()) {
                                Label(title: {
                                    Text("О Приложении")
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
                    .listStyle(InsetGroupedListStyle())
                    .scaledToFit()
                    
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: .infinity, maxHeight: .infinity, alignment: .top)
            .fixedSize(horizontal: false, vertical: false)
            .background(Color.appBackground.ignoresSafeArea())

        }
        .sheet(isPresented: $isLoginMenu, content: {
            AccountView()
        })
    }
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu()
    }
}
