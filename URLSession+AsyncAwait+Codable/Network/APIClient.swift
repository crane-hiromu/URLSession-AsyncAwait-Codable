//
//  APIClient.swift
//  URLSession+AsyncAwait+Codable
//
//  Created by h.crane on 2021/06/22.
//

import Foundation
import SwiftUI
import Combine

@available(iOS 15, *)
struct APICliant {
    
    // MARK: Variables

    private static let successRange = 200..<300
    private static let decorder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    
    // MARK: Method
    
    static func call<T, V>(_ request: T) async throws -> V
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
        
        let result = try await URLSession.shared.data(for: request.asURLRequest())
        let data = try validate(data: result.0, response: result.1)
        return try decorder.decode(V.self, from: data)
    }
    
    static func validate(data: Data, response: URLResponse) throws -> Data {
        
        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw NSError(domain: String(data: data, encoding: .utf8) ?? "Network Error", code: 0)
        }
        guard successRange.contains(code) else {
            throw NSError(domain: "out of statusCode range", code: code)
        }
        return data
    }
    
    static func validateCode(data: Data, response: URLResponse) throws -> Data {
        switch (response as? HTTPURLResponse)?.statusCode {
        case .some(let code) where code == 401:
            throw NSError(domain: "Unauthorized", code: code)
            
        case .some(let code) where code == 404:
            throw NSError(domain: "Not Found", code: code)
            
        case .none:
            throw NSError(domain: "Irregular Error", code: 0)
            
        case .some:
            return data
        }
    }
}

@available(iOS 15, *)
final class APIUseCase: APIUseCasable, APIUseCaseInputs, APIUseCaseOutputs {
    
    // MARK: APIUseCasable
    
    var inputs: APIUseCaseInputs { self }
    var outputs: APIUseCaseOutputs { self }
    
    // MARK: APIUseCaseOutputs
    
//    @Published var users = [UserModel]()
    var users = PassthroughSubject<[UserModel], Never>()
    
    // MARK: APIUseCaseInputs
    
    func fetch() async {
        do {
            let request = UserRequest()
            let response = try await APICliant.call(request)
            // users = response.data
            users.send(response.data)
            
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}

protocol APIUseCasable {
    var inputs: APIUseCaseInputs { get }
    var outputs: APIUseCaseOutputs { get }
}

protocol APIUseCaseInputs {
    func fetch() async
}

protocol APIUseCaseOutputs {
    var users: PassthroughSubject<[UserModel], Never> { get set }
}
