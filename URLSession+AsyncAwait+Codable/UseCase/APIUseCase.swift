//
//  APIUseCase.swift
//  URLSession+AsyncAwait+Codable
//
//  Created by h.crane on 2021/07/04.
//

import SwiftUI
import Combine

@available(iOS 15, *)
final class APIUseCase: APIUseCasable, APIUseCaseInputs, APIUseCaseOutputs {
    
    // MARK: APIUseCasable
    
    var inputs: APIUseCaseInputs { self }
    var outputs: APIUseCaseOutputs { self }
    
    // MARK: APIUseCaseOutputs
    
    // @Published var users = [UserModel]()
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
