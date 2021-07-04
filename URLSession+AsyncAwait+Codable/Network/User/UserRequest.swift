//
//  UserRequest.swift
//  URLSession+AsyncAwait+Codable
//
//  Created by h.crane on 2021/06/22.
//

import Foundation
import Alamofire

// MARK: - Request
struct UserRequest: BaseRequestProtocol {
    typealias ResponseType = UserResponse

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        return "/data"
    }

    var parameters: Parameters? {
        return nil
    }
}
