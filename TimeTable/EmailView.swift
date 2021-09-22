//
//  EmailView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 15.09.2021.
//

import SwiftUI

struct EmailView: View {
    
    @Binding var user: user
    @State var isAunthEmail: Bool? = nil
    @Environment(\.presentationMode) var presentationMode
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var wasSended: Bool = false
    @State var time: Int = 60
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button("Назад") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.cardEnable)
                .font(Font.appBold(size: 20))
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text("Почта")
                .foregroundColor(Color.cardEnable)
                .font(Font.appBold(size: 32))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            
            Text(user.email!)
                .foregroundColor((isAunthEmail != nil && isAunthEmail!) ? Color.cardEnable : Color.cardEnableLight)
                .font(Font.appBold(size: 20))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
            
            
            if(isAunthEmail != nil) {
                if(!isAunthEmail!) {
                    Text("Ваша почта не подтверждена, проверьте свой почтовый ящик на наличие письма.\n\nЕсли же письмо не пришло, то нажмите на кнопку киже, чтобы отправить письмо повторно.")
                        .foregroundColor(Color.cardEnableLight)
                        .font(Font.appMedium(size: 16))
                    
                    Button( "Отправить повторно" + (wasSended ? " \(time / 60):\(time % 60)" : "")) {
                        time = 60
                        wasSended = true
                        
                        postRequest(action: "send_confirmation_email", values: ["login": user.login, "session": user.session], onSucsess: {data, session, error in
//                            if let data = data {
//
//                            }
                        })
                    }
                    .padding(16)
                    .disabled(wasSended)
                    .font(Font.appMedium(size: 16))
                    .foregroundColor(wasSended ? Color.cardEnableLight : Color.cardEnable)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .foregroundColor(wasSended ? Color.cardDisable : Color.appBackground)
                    )
                } else {
                    Text("Почта подтверждена.")
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appMedium(size: 16))

                }
                
                Spacer()
            } else {
                Text("Загрузка")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(Color.cardEnableLight)
                    .font(Font.appMedium(size: 16))
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .onAppear {
            postRequest(action: "check_account_confirmation", values: ["login": user.login, "session": user.session], onSucsess: {data, response, error in
                if let data = data {
                    let json = toDictionary(data: data)!
                    
                    if((json["error"] as! [String: Any])["code"] as! Int == 0) {
                        isAunthEmail = true
                    } else if((json["error"] as! [String: Any])["code"] as! Int == 10) {
                        isAunthEmail = false
                    } else {
                        //TODO: error
                    }

                } else {
                    //TODO: error
                }
            })
        }
        .onReceive(timer, perform: {_ in
            if(wasSended) {
                time -= 1
                if(time == 0) {
                    wasSended = false
                }
            }
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView(user: .constant(user.empty))
    }
}
