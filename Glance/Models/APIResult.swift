//
//  APICurrency.swift
//  Glance
//
//  Created by Nazarii Zomko on 27.03.2023.
//

import Foundation


struct APIResult: Codable {
    var date: Date
    var currencyRates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case date
        case currencyRates = "usd"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateString = try container.decode(String.self, forKey: .date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString) ?? Date()
        self.date = date
        
        self.currencyRates = try container.decode([String : Double].self, forKey: .currencyRates)
    }
}
