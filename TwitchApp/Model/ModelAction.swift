//
//  ModelAction.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import Foundation

enum ModelAction {
    
    enum App {
    
        struct Launched: Action {}
        
        struct Activated: Action {}
        
        struct Inactivated: Action {}
    }
}
