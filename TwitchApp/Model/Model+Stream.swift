//
//  Model+Stream.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import Foundation

extension Model {
    
    func handleGetStreamList(pagination: String) async throws -> GameListModel {
        
        let command = ServerCommands.StreamController.GetStreamModel(token: token, clientId: clientId, pagination: pagination)
        
        return try await serverAgent.executeCommand(command: command)
    }
}
