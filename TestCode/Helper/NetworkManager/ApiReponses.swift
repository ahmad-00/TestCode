//
//  ApiReponses.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import Foundation

extension URLSession {
    
    func pokomonsTask(with urlRequest: URLRequest, completionHandler: @escaping (PokomonResponse?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.decodableTask(with: urlRequest, completionHandler: completionHandler)
    }
    
    func pokomonDetailTask(with urlRequest: URLRequest, completionHandler: @escaping (PokomonDetail?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.decodableTask(with: urlRequest, completionHandler: completionHandler)
    }

}

