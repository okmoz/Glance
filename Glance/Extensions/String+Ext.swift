//
//  String+Ext.swift
//  Glance
//
//  Created by Nazarii Zomko on 13.04.2023.
//

import Foundation

extension String {
    func containsMathSign() -> Bool {
        Constants.mathSigns.contains(where: { self.contains($0) })
    }
    
    func isLastCharacterMathSign() -> Bool {
        Constants.mathSigns.contains(String(self.suffix(1)))
    }
    
    func replacingLastCharacter(with replacement: String) -> String {
        self.dropLast().appending(replacement)
    }
    
    func droppingLastIfMathSign() -> String {
        self.isLastCharacterMathSign() ? String(self.dropLast()) : self
    }
    
    func convertingToValidMathExpression() -> String {
        // MathExpression dependency accepts only "*" and "/"
        // FIXME: ->
        // make separate steps, it reads better
        // handle only a symbol inside a string
        // maybe move this method in a separate model like CalculatorManager
        return self.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "×", with: "*").replacingOccurrences(of: "÷", with: "/").droppingLastIfMathSign()
    }
    
    func formatAsCurrency(minimumFractionDigits: Int, maximumFractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.locale = Locale(identifier: "en_US")
        guard let number = Double(self) else { return self }
        return formatter.string(from: NSNumber(value: number)) ?? self
    }
    
    // don't like the naming of these but can't think of anything better
    func formatNumberAddingCommas(minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 2) -> String {
        // handles exception when number ends with "."; "12345678." -> "12,345,678."
        if self.hasSuffix(".") {
            let numberWithoutDot = String(self.dropLast())
            let numberAsCurrency = numberWithoutDot.formatAsCurrency(minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
            return numberAsCurrency.appending(".")
        } else {
            return self.formatAsCurrency(minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
        }
    }
    
    func formatNumberRemovingCommas() -> String {
        self.replacingOccurrences(of: ",", with: "")
    }
}

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        max(-exponent, 0)
    }
}
