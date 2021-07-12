//
//  ApiReponseCheck.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import Foundation

// MARK: - ErrorHandler
extension BaseNetworkManager {
    static func reponseCheck<T>(data: T?, response: URLResponse?, error: Error?) throws -> T {
        if error != nil {
            throw ApiError.Server
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 401 || httpResponse.statusCode == 403 {
                throw ApiError.Authentication
            }
            if !(200...299).contains(httpResponse.statusCode) {
                throw ApiError.Server
            }
        }else {
            throw ApiError.Server
        }
        
        guard let data = data else {
            throw ApiError.Server
        }
        
        return data
    }
    
}
