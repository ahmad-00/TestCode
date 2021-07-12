//
//  BaseNetworkManager.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import Foundation

enum HttpRequestMethod: String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

class BaseNetworkManager {
    
    func pokomonRequest(url: URL, method: HttpRequestMethod, offset: Int, limit: Int = 20) -> URLRequest? {

        
        guard var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        let queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        urlComponent.queryItems = queryItems
        return URLRequest(url: urlComponent.url!)
        
    }
    
    
    
}

