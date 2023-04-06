//
//  APICurrency.swift
//  Glance
//
//  Created by Nazarii Zomko on 27.03.2023.
//

import Foundation


struct CurrencyRatesWithDate {
    var date: Date
    var currencyRates: [String: Double]
}


extension CurrencyRatesWithDate: Codable {
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        try container.encode(dateString, forKey: .date)
        try container.encode(currencyRates, forKey: .currencyRates)
    }
}
