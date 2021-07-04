//
//  APIUseCasable.swift
//  URLSession+AsyncAwait+Codable
//
//  Created by h.crane on 2021/07/04.
//

import Combine

// MARK: - UseCase Protocol
protocol APIUseCasable {
    var inputs: APIUseCaseInputs { get }
    var outputs: APIUseCaseOutputs { get }
}

// MARK: - Inputs
protocol APIUseCaseInputs {
    func fetch() async
}

// MARK: - Outputs
protocol APIUseCaseOutputs {
    var users: PassthroughSubject<[UserModel], Never> { get set }
}
