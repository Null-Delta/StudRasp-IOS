//
//  MainMenu.swift
//  TimeTable
//
//  Created by Рустам Хахук on 01.09.2021.
//

import SwiftUI

struct MainMenu: View {
    @StateObject var timeTable: TimeTable = TimeTable.empty
    
    @State var isAddingTable: Bool = false

    @State var addingCode: String = ""
                
    init() {
        let tabBarAppeareance = UITabBarAppearance()
        tabBarAppeareance.configureWithTransparentBackground()
        tabBarAppeareance.shadowImage = .shadowImage
        tabBarAppeareance.backgroundColor = UIColor(named: "App Background")
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppeareance
        }
        
        UITabBar.appearance().standardAppearance = tabBarAppeareance
        UITableView.appearance().backgroundColor = UIColor(named: "App Background")
    }
    
    var body: some View {
        VStack {
            TabView() {
                TimeTableView()
                    .tabItem {
                        Image("home")
                    }
                
                SettingsMenu()
                    .tabItem {
                        Image("settings")
                    }
            }
            .accentColor(Color.cardEnable)
            .background(Color.appBackground)
            .tabViewStyle(DefaultTabViewStyle())
            .onAppear {
                timeTable.setValues(table: try! JSONDecoder().decode(TimeTable.self, from: (UserDefaults.standard.string(forKey: "timetable") ?? String(data: JSONEncoder().encode(TimeTable.empty), encoding: .utf8)!).data(using: .utf8)!))
            }
        }
        .environmentObject(timeTable)
        .onOpenURL(perform: {url in
            if(url.absoluteString.hasPrefix("studrasp://addTable/") && !isAddingTable) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    addingCode = url.lastPathComponent
                    isAddingTable = true
                }
            }
        })
        .sheet(isPresented: $isAddingTable, onDismiss: nil, content: {
            TablePreviewView(code: $addingCode)
                .environmentObject(timeTable)
        })
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
            .preferredColorScheme(.light)
    }
}
