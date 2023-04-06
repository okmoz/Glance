//
//  PersistenceManager.swift
//  Glance
//
//  Created by Nazarii Zomko on 04.04.2023.
//

import Foundation

enum PersistenceManager {
    static private let userDefaults = UserDefaults.standard
    
    enum Keys {
        static let ratesWithDate = "ratesWithDate"
    }
    
    static func load() throws -> CurrencyRatesWithDate {
        guard let ratesResultData = userDefaults.object(forKey: Keys.ratesWithDate) as? Data else {
            throw GLError.errorLoadingRatesResultFromUserDefaults
        }
        do {
            let ratesResult = try JSONDecoder().decode(CurrencyRatesWithDate.self, from: ratesResultData)
            return ratesResult
        } catch {
            throw GLError.errorDecodingRatesResultFromUserDefaults
        }
    }
    
    static func save(currencyRatesWithDate: CurrencyRatesWithDate) throws {
        let encodedRatesResult = try JSONEncoder().encode(currencyRatesWithDate)
        userDefaults.set(encodedRatesResult, forKey: Keys.ratesWithDate)
        print("Successfully saved currency rates")
    }
}
