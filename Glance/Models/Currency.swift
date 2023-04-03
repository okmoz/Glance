//
//  Currency.swift
//  Glance
//
//  Created by Nazarii Zomko on 16.03.2023.
//

import UIKit

struct Currency: Hashable {
    let code: String
    let name: String
    let symbol: String
    var rate: Double
    var icon: UIImage { IconManager.getIcon(for: self) }
}
