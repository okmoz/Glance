//
//  Double+Ext.swift
//  Glance
//
//  Created by Nazarii Zomko on 11.04.2023.
//

import Foundation

extension Double {
    // Example: 128834.567891000 -> "128834.567891"
    func stringWithoutZeroFraction() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return String(formatter.string(from: number) ?? String(format: "%g", self))
    }
}
