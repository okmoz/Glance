//
//  PersistenceManager.swift
//  Glance
//
//  Created by Nazarii Zomko on 04.04.2023.
//

import Foundation

// 3 locations for rates:
// 1. default rates in Constants: available always (when no internet and no new rates have been pulled from the API)
// 2. UserDefaults: available if user pulled rates at least once from the API) - re-saved to UserDefaults if date of pulled rates is newer than a date of saved rates
// 3. in memory: used most often; available if user has access to internet and was able to pull the latest rates from the API; when successfully pulled, save to "rates" property and save to UserDefaults

enum PersistenceManager {
    static private let userDefaults = UserDefaults.standard
    
    enum Keys {
        static let ratesWithDate = "ratesWithDate"
    }
    
    static func loadCurrencyRatesWithDate() throws -> CurrencyRatesWithDate {
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
