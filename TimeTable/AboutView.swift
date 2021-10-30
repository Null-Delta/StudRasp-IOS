//
//  AdoutView.swift
//  TimeTable
//
//  Created by Рустам Хахук on 29.10.2021.
//

import SwiftUI

struct ChelInfo: View {
    @State var image: UIImage = UIImage()
    @State var name: String = ""
    @State var info: String = ""
    @State var email: String = ""
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 16) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64, alignment: .leading)
                    .clipShape(Circle())
                
                VStack(spacing: 8) {
                    Text(name)
                        .fixedSize(horizontal: false, vertical: false)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appBold(size: 20))
                        .lineLimit(nil)
                    
                    Text(email)
                        .fixedSize(horizontal: false, vertical: false)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .foregroundColor(Color.cardEnable)
                        .font(Font.appMedium(size: 16))
                        .lineLimit(nil)
                    
                    Text(info)
                        .font(Font.appMedium(size: 16))
                        .foregroundColor(Color.cardEnableLight)
                        .fixedSize(horizontal: false, vertical: false)
                        .frame(maxWidth: .infinity,maxHeight: 60, alignment: .topLeading)
                }
                
            }
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("О Приложении")
                    .font(Font.appBlack(size: 32))
                    .foregroundColor(Color.cardEnable)
                    .fixedSize(horizontal: false, vertical: false)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                
                Text("В очередной раз увидев, как деканат вывешивает новое распечатанное расписание на доску, мы поняли, что так жить больше нельзя. \n\nЭто стало причиной существования данной программы. ")
                    
                    .font(Font.appMedium(size: 16))
                    .foregroundColor(Color.cardEnable)
                    .fixedSize(horizontal: false, vertical: false)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                Text("Разработчики")
                    .font(Font.appBlack(size: 32))
                    .foregroundColor(Color.cardEnable)
                    .fixedSize(horizontal: false, vertical: false)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))


                
                ChelInfo(
                    image: UIImage(named: "zed")!,
                    name: "Хахук Рустам",
                    info: "Разработка клиента на IOS и Android",
                    email: "zed.null@icloud.com"
                )
                
                ChelInfo(
                    image: UIImage(named: "girya")!,
                    name: "Гиренко Даниил",
                    info: "Разработка клиента на Android, разработка cервера",
                    email: "iamgirya@yandex.ru"

                )
                
                ChelInfo(
                    image: UIImage(named: "serega")!,
                    name: "Прозоров Максим",
                    info: "Разработка cервера",
                    email: "starproxima@yandex.ru"
                )
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
        }
        .background(Color.appBackground.ignoresSafeArea())

    }
}

struct AdoutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
