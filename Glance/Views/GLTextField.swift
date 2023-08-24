//
//  GLTextField.swift
//  Glance
//
//  Created by Nazarii Zomko on 25.04.2023.
//

import UIKit

class GLTextField: UITextField {
    var isOnSelectedCell = false
    
    var number: String {
        get {
            self.text?.formatNumberRemovingCommas() ?? ""
        }
        set {
            let minimumFractionDigits = isOnSelectedCell ? 0 : 4
            let maximumFractionDigits = isOnSelectedCell ? 8 : 4
            self.text = newValue.formatNumberAddingCommas(minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
        }
    }
    
    var placeholderNumber: String {
        get {
            self.placeholder?.formatNumberRemovingCommas() ?? ""
        }
        set {
            self.placeholder = newValue.formatNumberAddingCommas(minimumFractionDigits: 2, maximumFractionDigits: 2)
        }
    }
}
