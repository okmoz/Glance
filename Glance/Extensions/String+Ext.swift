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
        // make separate steps, it reads better
        // handle only a symbol inside a string
        // maybe move this method in a separate model like CalculatorManager
        return self.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "×", with: "*").replacingOccurrences(of: "÷", with: "/").droppingLastIfMathSign()
    }
}
