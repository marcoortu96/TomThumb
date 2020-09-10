//
//  CheckFirstLaunch.swift
//  TomThumb
//
//  Created by Marco Ortu on 07/09/2020.
//  Copyright © 2020 Sora. All rights reserved.
//
import UIKit

private var firstLaunch : Bool = false

extension UIApplication {
    
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "isFirstLaunchFlag"
        let isFirstLaunch = UserDefaults.standard.string(forKey: firstLaunchFlag) == nil
        if (isFirstLaunch) {
            firstLaunch = isFirstLaunch
            UserDefaults.standard.set("false", forKey: firstLaunchFlag)
            UserDefaults.standard.synchronize()
        }
        return firstLaunch || isFirstLaunch
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
    
    static var counter = -1
    
    static var colors: [[UIColor]] = [[UIColor(rgb: 0x194865), UIColor(rgb: 0x6a4ea6)],
                                      [UIColor(rgb: 0xd489b2), UIColor(rgb: 0xdaba95)],
                                      [UIColor(rgb: 0x606d2d), UIColor(rgb: 0x88a050)],
                                      [UIColor(rgb: 0x00c6cc), UIColor(rgb: 0x008d92)],
                                      [UIColor(rgb: 0xe5c33b), UIColor(rgb: 0x60a870)],
                                      [UIColor(rgb: 0x37c36b), UIColor(rgb: 0xd67dc5)],
                                      [UIColor(rgb: 0xe69811), UIColor(rgb: 0x5b8bb0)],
                                      [UIColor(rgb: 0xc04808), UIColor(rgb: 0xd86060)],
                                      [UIColor(rgb: 0x80b0a8), UIColor(rgb: 0xe69f5f)]]
    
    static func getColor(i: Int, j: Int) -> UIColor {
        return colors[i % colors.count][j % 2]
        
    }
}

extension String {
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
