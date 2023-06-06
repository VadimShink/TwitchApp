//
//  TwitchAppApp.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import SwiftUI

@main
struct TwitchAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var model: Model {
        
        let environment = ServerAgent.Environment.test
        
        let serverAgent = ServerAgent(environment: environment)
        
        let model = Model(serverAgent: serverAgent)
        
        return model
    }
    
    var mainViewModel: MainViewModel {
        
        return MainViewModel(model: model)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: mainViewModel)
        }
    }
}
