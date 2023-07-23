//
//  DataResponseModel.swift
//  lab04hw
//
//  Created by Никита Зорин on 04.07.2023.
//

import Foundation

struct DataResponseModel: Codable {
    struct Info: Codable {
            let count: Int
            let pages: Int
            let next: String?
            let prev: String?
        }

    let info: Info
    let results: [Character]
    struct Location: Codable {
        var name: String
        let url: String
    }
    struct Character: Codable {
        let id: Int
        let name: String
        let status: String
        var species: String
        let gender: String
        var location: Location
        let image: String
    }
    enum CodingKeys: String, CodingKey {
        case info, results
    }
}


