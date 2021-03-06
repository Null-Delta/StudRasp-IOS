//
//  Fonts.swift
//  TimeTable
//
//  Created by Рустам Хахук on 01.09.2021.
//

import SwiftUI
import CommonCrypto
import Combine

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
    
    static var cardEnableLight: Color {
        get {
            return Color("Card Enable Light")
        }
    }
    
    static var cardDisableLight: Color {
        get {
            return Color("Card Disable Light")
        }
    }
    
    static var shadow: Color {
        get {
            return Color("Shadow")
        }
    }
    
    static var warning: Color {
        get {
            return Color("Warning")
        }
    }
    
    static var warningEnable: Color {
        get {
            return Color("Warning Enable")
        }
    }
    
    static var warningDisable: Color {
        get {
            return Color("Warning Disable")
        }
    }
}

extension UIImage {
    static var shadowImage: UIImage {
        get {
            return UIImage(named: "divider")!
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

extension Data{
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

public extension String {
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
}


struct error: Codable {
    var code: Int
    var message: String
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


struct AlertControl: UIViewControllerRepresentable {

    @Binding var textString: String
    @Binding var show: Bool

    var title: String
    var message: String
    
    var onSubmit: () -> ()


    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertControl>) -> UIViewController {
        return UIViewController() // holder controller - required to present alert
    }

    func updateUIViewController(_ viewController: UIViewController, context: UIViewControllerRepresentableContext<AlertControl>) {
        guard context.coordinator.alert == nil else { return }
        if self.show {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = alert

            alert.addTextField { textField in
                textField.placeholder = "Enter some text"
                textField.text = self.textString            // << initial value if any
                textField.delegate = context.coordinator    // << use coordinator as delegate
            }
            alert.addAction(UIAlertAction(title: "cancel", style: .destructive) { _ in
                // your action here
            })
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
                onSubmit()
            })

            DispatchQueue.main.async { // must be async !!
                viewController.present(alert, animated: true, completion: {
                    self.show = false  // hide holder after alert dismiss
                    context.coordinator.alert = nil
                })
            }
        }
    }

    func makeCoordinator() -> AlertControl.Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var alert: UIAlertController?
        var control: AlertControl
        init(_ control: AlertControl) {
            self.control = control
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                self.control.textString = text.replacingCharacters(in: range, with: string)
            } else {
                self.control.textString = ""
            }
            return true
        }
    }
}


func postRequest(action: String, values: [String:String], onSucsess: @escaping (Data?, URLResponse?, Error?) -> ()) {
    let url = URL(string: "https://\(mainDomain)/main.php")!
    
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    
    components.queryItems = [
        URLQueryItem(name: "action", value: action)
    ]
    
    for i in values {
        components.queryItems!.append(URLQueryItem(name: i.key, value: i.value))
    }
    
    var request = URLRequest(url: url)
    
    request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
    request.httpMethod = "POST"
    request.httpBody = Data(components.url!.query!.utf8)
    request.timeoutInterval = 5

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        onSucsess(data, response, error)
    }
    
    task.resume()
}

func toDictionary(data: Data) -> [String: Any]? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch {
        print(error.localizedDescription)
    }
    
    return nil
}
