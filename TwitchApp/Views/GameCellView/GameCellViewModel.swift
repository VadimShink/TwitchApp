//
//  GameCellViewModel.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import Foundation
import SwiftUI


class GameCellViewModel: Identifiable, ObservableObject {
    
    let id: String
    let name: String
    let imageURL: String?
    let action: (String) -> Void
    
    init(id: String, name: String, imageURL: String?, action: @escaping (String) -> Void) {
        
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.action = action
    }
    
    convenience init(game: GameListModel.Game, action: @escaping (String) -> Void) {
        
        let imageURL = game.boxArtURL.replacingOccurrences(of: "{width}", with: "200")
                                      .replacingOccurrences(of: "{height}", with: "300")
        
        self.init(id: game.id, name: game.name, imageURL: imageURL, action: action)
    }
}
