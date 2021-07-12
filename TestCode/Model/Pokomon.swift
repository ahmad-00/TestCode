//
//  Pokomon.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import Foundation

struct PokomonResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: Pokomons?
}

// MARK: - Result
struct Pokomon: Codable {
    let name: String?
    let url: String?
    var details: PokomonDetail?
}

typealias Pokomons = Array<Pokomon>
