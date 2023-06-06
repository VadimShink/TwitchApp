//
//  GameListModel.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import Foundation

struct GameListModel: Codable {
    
    let data: [Game]
    let pagination: Pagination
    
    struct Game: Codable {
        
        let id: String
        let name: String
        let boxArtURL: String
        let igdbID: String

        enum CodingKeys: String, CodingKey {
            case id, name
            case boxArtURL = "box_art_url"
            case igdbID = "igdb_id"
        }
    }

    struct Pagination: Codable {
        let cursor: String
    }
}


