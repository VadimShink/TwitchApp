//
//  Model.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import Foundation
import Combine

class Model {
    
    //MARK: Interface
    let action: PassthroughSubject<Action, Never> = .init()
    
    //MARK: Services
    let serverAgent: ServerAgentProtocol
    
    //MARK: - Private
    private var bindings: Set<AnyCancellable>
    private let queue = DispatchQueue(label: "Vadim.Shinkarenko.TwitchApp", qos: .userInitiated, attributes: .concurrent)
    
    var token: String? = "5w8mzxl25d91kzjvfn86grlpn9d3kw"
    var clientId: String? = "dqa46yk7jedbmjwpk35hyj4isv3dqb"
    
    init(serverAgent: ServerAgentProtocol) {
        self.serverAgent = serverAgent
        self.bindings = []
        
        bind()
    }
    
    // MARK: - Bind
    private func bind() {
        
    }
}

//MARK: - EmptyMock
/// Для превью
extension Model {
    
    static var emptyMock: Model {
        
        let environment = ServerAgent.Environment.test
        
        let serverAgent = ServerAgent(environment: environment)
        
        let model = Model(serverAgent: serverAgent)
        
        return model
    }
}
