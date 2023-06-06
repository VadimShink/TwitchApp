//
//  ErrorMetadata.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import Foundation

struct ErrorMetadata: Codable {
    
    let errors: [Error]?
    let messages: Messages?
    
    struct Error: Codable {
        
        let id: String
        let messages: [String]
    }
    
    
    struct Messages: Codable {
        let common: [String]
    }
}
