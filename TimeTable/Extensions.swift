//
//  Fonts.swift
//  TimeTable
//
//  Created by Рустам Хахук on 01.09.2021.
//

import SwiftUI
import CommonCrypto

extension Font {
    static func appMedium(size: CGFloat) -> Font {
        return Font.custom("Roboto-Medium", size: size)
    }
    
    static func appBold(size: CGFloat) -> Font {
        return Font.custom("Roboto-Bold", size: size)
    }
    
    static func appBlack(size: CGFloat) -> Font {
        return Font.custom("Roboto-Black", size: size)
    }
}

extension Color {
    static var appBackground: Color {
        get {
            return Color("App Background")
        }
    }
    
    static var cardDisable: Color {
        get {
            return Color("Card Background Disable")
        }
    }
    
    static var cardEnable: Color {
        get {
            return Color("Card Background Enable")
        }
    }
}

extension UIImage {
    static var shadowImage: UIImage {
        get {
            return UIGraphicsImageRenderer(size: CGSize(width: 1, height: 2)).image(actions: {ctx in
                ctx.cgContext.setFillColor(UIColor(named: "Card Background Disable")!.cgColor)
                ctx.cgContext.addRect(CGRect(origin: .zero, size: CGSize(width: 1, height: 2)))
                ctx.cgContext.fillPath()
            })
        }
    }
}

extension Date {
    
    var startOfWeek: Date {
        if(self.weekDay == 7) {
            let gregorian = Calendar(identifier: .gregorian)
            let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
            return gregorian.date(byAdding: .day, value: -6, to: sunday)!
        }
        
        
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return gregorian.date(byAdding: .day, value: 1, to: sunday)!
    }
    
    func addDays(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func addMinutes(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
    
    var weekDay: Int {
        get {
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.weekday], from: self)
            let dayOfWeek = components.weekday
            return 1 + (dayOfWeek! + 5) % 7
        }
    }
    
    var weekIndex: Int {
        get {
            let week = Calendar(identifier: .gregorian).component(.weekOfYear, from: self.startOfWeek)
            return week % 2
        }
    }
    
    var day: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        let dayOfMonth = components.day
        
        return dayOfMonth!
    }
    
    var minutes: Int {
        return Calendar.current.component(.hour, from: self) * 60 + Calendar.current.component(.minute, from: self)
    }
    
    var dayAbr: String {
        get {
            switch weekDay {
            case 1:
                return "Пн"
            case 2:
                return "Вт"
            case 3:
                return "Ср"
            case 4:
                return "Чт"
            case 5:
                return "Пт"
            case 6:
                return "Сб"
            case 7:
                return "Вс"
            default:
                return ""
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

func hashSHA256(data:Data) -> Data? {
    var hashData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
    
    _ = hashData.withUnsafeMutableBytes {digestBytes in
        data.withUnsafeBytes {messageBytes in
            CC_SHA256(messageBytes, CC_LONG(data.count), digestBytes)
        }
    }
    
    return hashData
}


struct error: Codable {
    var code: Int
    var message: String
}
