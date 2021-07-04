//
//  UserResponse.swift
//  URLSession+AsyncAwait+Codable
//
//  Created by h.crane on 2021/06/22.
//

// MARK: - Response
struct UserResponse: Codable {
    var data: [UserModel]
    
    init(from decoder: Decoder) throws {
        data = try decoder.singleValueContainer().decode([UserModel].self)
    }
}

struct UserModel: Codable {
    let name: String
    let id: Int
}
