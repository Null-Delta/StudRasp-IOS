//
//  ValueSelectorView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 10.09.2021.
//

import SwiftUI

struct ValueSelectorView: View {
    @Binding var value: String
    @Binding var title: String
    
    @Binding var defaults: DefaultsName
    
    @State var savedValues: [String] = []
    @State var isAddingValue: Bool = false
    @State var newValue: String = ""
    
    var action: (String) -> () = {_ in }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Отмена") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(16)
                .foregroundColor(Color.cardEnable)
                .font(Font.appMedium(size: 20))
                
                Spacer()
            }
            
            Text(title)
                .foregroundColor(Color.cardEnable)
                .font(Font.appBold(size: 32))
                .frame(maxWidth: .infinity, minHeight: 42, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(0..<savedValues.count, id: \.self) { index in
                        if(savedValues[index] != "") {
                            ValueView(value: $savedValues[index], values: $savedValues, defaults: $defaults)
                                .onTapGesture {                                    
                                    action(savedValues[index])
                                                                        
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                isAddingValue = true
            }, label: {
                Text("Добавить")
                    .font(Font.appMedium(size: 20))
                    .foregroundColor(Color.appBackground)
                    .frame(maxWidth: .infinity, minHeight: 48)
            })
            .background(
                AlertControl(textString: $newValue, show: $isAddingValue, title: "Новая запись", message: "") {
                    savedValues.append(newValue)
                    UserDefaults.standard.set(savedValues, forKey: defaults.rawValue)

                    newValue = ""
                }
            )
            .frame(maxWidth: .infinity, minHeight: 48)
            
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(Color.cardEnable)
            )
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))

        }
        .onAppear {
            savedValues = UserDefaults.standard.stringArray(forKey: defaults.rawValue) ?? []
            savedValues.removeAll(where: {val in val == ""})
            UserDefaults.standard.set(savedValues, forKey: defaults.rawValue)
        }
        .onOpenURL(perform: {url in
            presentationMode.wrappedValue.dismiss()
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ValueView: View {
    @Binding var value: String
    @Binding var values: [String]
    @Binding var defaults: DefaultsName
    
    @State var isDeleting: Bool = false
    
    var body: some View {
        HStack {
            Text(value)
                .foregroundColor(Color.cardEnable)
                .font(Font.appMedium(size: 16))
                .padding(8)
            Spacer()
            
            Button(action: {
                isDeleting = true
            }, label: {
                Image(systemName: "trash")
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(Color.cardEnable)
            })
        }
        .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .foregroundColor(Color.cardDisableLight)
        )
        .actionSheet(isPresented: $isDeleting, content: {
            ActionSheet(title: Text("Удалить \(value)?"), buttons: [
                ActionSheet.Button.destructive(Text("Удалить")) {
                    values[values.firstIndex(where: {val in val == value})!] = ""
                    UserDefaults.standard.set(values, forKey: defaults.rawValue)
                },
                ActionSheet.Button.cancel()
            ])
        })
    }
}

struct ValueSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ValueSelectorView(value: .constant(""), title: .constant("Test"), defaults: .constant(DefaultsName.disciplines))
    }
}
