//
//  SettingsView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 12.09.2021.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var tables: SavedTables
    
    @State var name: String = ""
    @State var week1: String = ""
    @State var week2: String = ""
    
    @State var isTimeSettingsOpen: Bool = false
    
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        NavigationView{
            VStack {
                NavigationLink(isActive: $isTimeSettingsOpen, destination: {
                    TimeSettingsView(tables: tables)
                }, label: {})
                
                HStack {
                    Button("Отмена") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appMedium(size: 20))
                    .padding(16)
                    
                    Spacer()
                    
                    Button("Сохранить") {
                        if(tables.selectedType == .local) {
                            tables.localTables[tables.selectedTable].name = name
                            tables.localTables[tables.selectedTable].firstWeek = week1
                            tables.localTables[tables.selectedTable].secondWeek = week2
                            tables.objectWillChange.send()
                            
                            tables.saveArray(state: .local)
                            
                        } else {
                            tables.globalSavedTables[tables.globalSavedTables.firstIndex(where: {val in val.id == tables.selectedID})!].table.name = name
                            tables.globalSavedTables[tables.globalSavedTables.firstIndex(where: {val in val.id == tables.selectedID})!].table.firstWeek = week1
                            tables.globalSavedTables[tables.globalSavedTables.firstIndex(where: {val in val.id == tables.selectedID})!].table.secondWeek = week2
                            tables.objectWillChange.send()
                            
                            tables.saveArray(state: .global)
                            
                        }
                        
                        presentationMode.wrappedValue.dismiss()

                    }
                    .disabled(name.replacingOccurrences(of: " ", with: "") == "")
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appMedium(size: 20))
                    .padding(16)

                }
                
                Text("Настройки")
                    .foregroundColor(Color.cardEnable)
                    .font(Font.appBold(size: 32))
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    VStack {
                        HStack {
                            Text("Название")
                                .foregroundColor(.cardEnable)
                                .font(Font.appMedium(size: 16))
                            
                            Spacer()
                        }
                        
                        TextField("", text: $name)
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
                            Text("Первая неделя")
                                .foregroundColor(.cardEnable)
                                .font(Font.appMedium(size: 16))
                            
                            Spacer()
                        }
                        
                        TextField("", text: $week1)
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
                            Text("Вторая неделя")
                                .foregroundColor(.cardEnable)
                                .font(Font.appMedium(size: 16))
                            
                            Spacer()
                        }
                        
                        TextField("", text: $week2)
                            .frame(height: 36, alignment: .center)
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .foregroundColor(Color.cardDisableLight)
                            )
                            .foregroundColor(.cardEnable)
                            .font(Font.appMedium(size: 20))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                        
                        Button(action: {
                            isTimeSettingsOpen = true
                        }, label: {
                            Text("Время пар")
                                .font(Font.appMedium(size: 16))
                                .foregroundColor(Color.appBackground)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .center)
                        })
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .foregroundColor(Color.cardEnable)
                            )
                    }
                    .padding(16)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                }
            }
            .onAppear(perform: {
                if(tables.selectedType == .local) {
                    name = tables.localTables[tables.selectedTable].name
                    week1 = tables.localTables[tables.selectedTable].firstWeek
                    week2 = tables.localTables[tables.selectedTable].secondWeek
                } else {
                    name = tables.globalSavedTables[tables.globalSavedTables.firstIndex(where: {val in val.id == tables.selectedID})!].table.name
                    week1 = tables.globalSavedTables[tables.globalSavedTables.firstIndex(where: {val in val.id == tables.selectedID})!].table.firstWeek
                    week2 = tables.globalSavedTables[tables.globalSavedTables.firstIndex(where: {val in val.id == tables.selectedID})!].table.secondWeek
                }
            })
            .onOpenURL(perform: {url in
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(tables: SavedTables())
    }
}
