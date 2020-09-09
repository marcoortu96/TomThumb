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
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
    
    static var colors: [UIColor] = [UIColor(red: 0.97, green: 0.8, blue: 0.58, alpha: 1), UIColor(red: 0.69, green: 0.88, blue: 0.53, alpha: 1), UIColor(red: 0.34, green: 0.67, blue: 0.81, alpha: 1), UIColor(red: 0.7, green: 0.18, blue: 0.58, alpha: 1), UIColor(red: 0.17, green: 0.48, blue: 0.4, alpha: 1), UIColor(red: 0.1, green: 0.28, blue: 0.58, alpha: 1)]
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
