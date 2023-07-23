//
//  Database.swift
//  RickApp
//
//  Created by Никита Зорин on 23.07.2023.
//

import Foundation

struct FavouriteData: Codable {
    let userId: Int
    let characterName: String
    let imageString: String?
}

final class Database {
    private let FAV_KEY = "fav_key"
    
    func save(items: [FavouriteData]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(items)
            UserDefaults.standard.set(data, forKey: FAV_KEY)
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func load() -> [FavouriteData] {
        do {
            if let data = UserDefaults.standard.data(forKey: FAV_KEY) {
                let decoder = JSONDecoder()
                let items = try decoder.decode([FavouriteData].self, from: data)
                return items
            }
        } catch {
            print("Error loading data: \(error)")
        }
        return []
    }
}

