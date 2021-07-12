//
//  ApiError.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import Foundation

enum ApiError: Error, Equatable {
    case Custom(desc: String)
    case Server
    case Authentication
    
    var localizedDescription: String {
        switch self {
        case .Server:
            return NSLocalizedString("Connection failed. please try again", comment: "")
        case .Authentication:
            return NSLocalizedString("Authentication failed", comment: "")
        case .Custom(let desc):
            return NSLocalizedString(desc, comment: "")
        }
    }
}
