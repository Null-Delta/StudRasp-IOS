//
//  MainMenu.swift
//  TimeTable
//
//  Created by Рустам Хахук on 01.09.2021.
//

import SwiftUI

struct MainMenu: View {
    @State var timeTable: ServerTimeTable = ServerTimeTable(id: -1, info: TimeTable.empty)
                
    init() {
        let tabBarAppeareance = UITabBarAppearance()
        tabBarAppeareance.configureWithTransparentBackground()
        tabBarAppeareance.shadowImage = .shadowImage
        tabBarAppeareance.backgroundColor = UIColor(named: "App Background")
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppeareance
        }
        UITabBar.appearance().standardAppearance = tabBarAppeareance
        
    }
    
    var body: some View {
        VStack {
            TabView() {
                TimeTableView(activeTimeTable: $timeTable, selectedDay: Date(timeIntervalSinceNow: 0).weekDay - 1)
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
                timeTable = try! JSONDecoder().decode(ServerTimeTable.self, from: (UserDefaults.standard.string(forKey: "timetable") ?? String(data: JSONEncoder().encode(ServerTimeTable(id: -1, info: TimeTable.empty)), encoding: .utf8)!).data(using: .utf8)!)
            }
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
