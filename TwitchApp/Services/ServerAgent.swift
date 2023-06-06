//
//  ServerAgent.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import Foundation
import Combine

class ServerAgent: NSObject, URLSessionDelegate, ServerAgentProtocol {
    
    let action: PassthroughSubject<Action, Never> = .init()
    
    private var baseURL: String { environment.baseURL }
    private let environment: Environment
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    private lazy var session: URLSession = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 600
        configuration.httpShouldSetCookies = false
        configuration.httpCookieAcceptPolicy = .never
        
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    init(environment: Environment) {
        self.environment = environment
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    func executeCommand<Command>(command: Command) async throws -> Command.Response where Command : ServerCommand {
        
        let request = try request(with: command)
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw ServerAgentError.emptyResponseData
        }
        
        if response.statusCode == 200 {
            
            self.action.send(ServerAgentAction.NetworkActivityEvent())
            
            if let empty = EmptyData() as? Command.Response {
                
                debugPrint("DEBUG Response Answer \(response.url?.absoluteString ?? "") Empty")
                return empty
                
            } else {
                
                do {
                    
                    let response = try decoder.decode(Command.Response.self, from: data)
                    return response
                    
                } catch {
                    
                    if error is DecodingError {
                        print("DecodingError in \(command.endpoint)\nError: \(error)")
                    }
                    throw ServerAgentError.curruptedData(error)
                }
            }
            
        } else {
            
            if response.statusCode == 401 {
                
                self.action.send(ServerAgentAction.NotAuthorized())
            }
            
            do {
                
                let response = try decoder.decode(ErrorMetadata.self, from: data)
                
                throw ServerAgentError.serverStatus(errorMessage: response.errors?.first?.messages.first ?? "")
                
            } catch {
                
                if error is DecodingError {
                    
                    print("DecodingError in \(command.endpoint)\nError: \(error)")
                }
                throw ServerAgentError.curruptedData(error, status: ServerAgentError.ResponseStatus(rawValue: response.statusCode))
            }
        }
    }
    
    func request<Command>(with command: Command) throws -> URLRequest where Command : ServerCommand {
        
        guard let url = URL(string: baseURL + command.endpoint) else {
            throw ServerRequestCreationError.unableConstructURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = command.method.rawValue
        
        //MARK: Token
        if let token = command.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        //MARK: ClientID
        if let clientId = command.clientId {
            request.setValue("\(clientId)", forHTTPHeaderField: "Client-Id")
        }
        
        //MARK: Parameters
        if let parameters = command.parameters, parameters.isEmpty == false {
            
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.name, value: $0.value) }
            
            guard let updatedURL = urlComponents?.url else {
                throw ServerRequestCreationError.unableCounstructURLWithParameters
            }
            
            request.url = updatedURL
        }
        
        //MARK: Body
        if let payload = command.payload {
            
            do {
                
                request.httpBody = try encoder.encode(payload)
                
            } catch {
                throw ServerRequestCreationError.unableEncodePayload(error)
            }
        }
        
        if request.httpBody != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}

extension ServerAgent {
    
    public enum Environment {
        
        case test
        case prod
        
        var baseURL: String {
            
            switch self {
                case .test:
                    return "https://api.twitch.tv"
                    
                case .prod:
                    return "https://api.twitch.tv"
            }
        }
    }
}
