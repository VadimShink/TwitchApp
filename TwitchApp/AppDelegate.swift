//
//  AppDelegate.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var model: Model {
        
        let environment = ServerAgent.Environment.test
        
        let serverAgent = ServerAgent(environment: environment)
        
        let model = Model(serverAgent: serverAgent)
        
        return model
    }
    
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
}
