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
}
