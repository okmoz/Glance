//
//  GLError.swift
//  Glance
//
//  Created by Nazarii Zomko on 28.03.2023.
//

import Foundation

enum GLError: Error {
    case noVisibleCells
    case emptyCurrencyRates
    case missingCurrencyRate(code: String)
}
