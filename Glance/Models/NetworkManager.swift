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
    
    func getAPIResult() async throws -> APIResult {
        let endpoint = baseURL
        
        guard let url = URL(string: endpoint) else { throw GLError.invalidURL }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let APIResult = try JSONDecoder().decode(APIResult.self, from: data)
        return APIResult
    }
}
