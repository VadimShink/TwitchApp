//
//  ServerCommands+Stream.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import Foundation

enum ServerCommands {
    
    enum StreamController {
        
        struct GetStreamModel: ServerCommand {
            
            let token: String?
            let clientId: String?
            var endpoint: String {
                "/helix/games/top?first=20&after=\(pagination)"
            }
            var pagination: String
            let method: ServerCommandMethod = .get
            let payload: Payload? = nil
            let parameters: [ServerCommandParameters]? = nil
            
            typealias Payload = EmptyData
            
            typealias Response = GameListModel
            
            init(token: String?, clientId: String?, pagination: String) {
                self.token = token
                self.clientId = clientId
                self.pagination = pagination
            }
        }
    }
}
