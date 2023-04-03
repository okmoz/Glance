//
//  IconManager.swift
//  Glance
//
//  Created by Nazarii Zomko on 23.03.2023.
//

import UIKit

enum IconManager {
    static func getIcon(for currency: Currency) -> UIImage {
        if let image = UIImage(named: currency.code) {
            return image
        } else {
            print("Error: Failed to get icon for currency \(currency). Recovering by creating an image from a currency symbol.")
            return createIconFromSymbol(currency.symbol != "" ? currency.symbol : currency.code)
        }
    }
    
    
    static func createIconFromSymbol(_ symbol: String) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .systemGray.withAlphaComponent(0.4)
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.text = symbol
        UIGraphicsBeginImageContext(frame.size)
         if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage ?? UIImage()
         }
        return UIImage()
    }
}
