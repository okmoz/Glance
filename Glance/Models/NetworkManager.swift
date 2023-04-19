//
//  NetworkManager.swift
//  Glance
//
//  Created by Nazarii Zomko on 27.03.2023.
//

import Foundation


// TODO: Make a closure-based request?

class NetworkManager {
    enum GLError: Error {
        case invalidURL, missingData
    }
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/usd.json"
    
    private init() {}
    
    func fetchCurrencyRatesWithDate() async throws -> CurrencyRatesWithDate {
        let endpoint = baseURL
        guard let url = URL(string: endpoint) else { throw GLError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let currencyRatesWithDate = try JSONDecoder().decode(CurrencyRatesWithDate.self, from: data)
//        try await Task.sleep(until: .now + .seconds(2), clock: .continuous)
        return currencyRatesWithDate
    }
}
