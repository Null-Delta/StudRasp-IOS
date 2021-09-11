//
//  ValueSelectorView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 10.09.2021.
//

import SwiftUI

struct ValueSelectorView: View {
    @Binding var value: String
    var title: String
    var defaults: DefaultsName
    
    @State var savedValues: [String] = []
    @State var isAddingValue: Bool = false
    @State var newValue: String = ""
    
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
                        ValueView(value: savedValues[index])
                            .onTapGesture {
                                value = savedValues[index]
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            }
            .frame(maxWidth: .infinity)
            
            Button("Добавить") {
                isAddingValue = true
            }
            .background(
                AlertControl(textString: $newValue, show: $isAddingValue, title: "Новая запись", message: "") {
                    savedValues.append(newValue)
                    UserDefaults.standard.setValue(savedValues, forKey: defaults.rawValue)
                    newValue = ""
                }
            )
            .frame(maxWidth: .infinity, minHeight: 36)
            .foregroundColor(Color.appBackground)
            .font(Font.appMedium(size: 16))
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(Color.cardEnable)
            )
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))

        }
        .onAppear {
            savedValues = UserDefaults.standard.stringArray(forKey: defaults.rawValue) ?? []
        }
    }
}

struct ValueView: View {
    var value: String
    
    var body: some View {
        HStack {
            Text(value)
                .foregroundColor(Color.cardEnable)
                .font(Font.appMedium(size: 16))
        }
        .frame(maxWidth: .infinity, minHeight: 36, alignment: .leading)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .foregroundColor(Color.cardDisableLight)
        )
    }
}

struct ValueSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ValueSelectorView(value: .constant(""), title: "Test", defaults: DefaultsName.disciplines)
    }
}
