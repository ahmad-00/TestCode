//
//  Endpoints.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import UIKit

// MARK: - URLs
extension BaseNetworkManager {
    enum Endpoint {
        case pokomonList
        
        var url: URL {
            var urlString = "https://pokeapi.co/api/v2/"
            
            switch self {
            case .pokomonList:
                urlString += "pokemon"
                break
            }
            
            return URL(string: urlString)!
        }
        
    }
}
