//
//  BaseAPIProtocol.swift
//  URLSession+AsyncAwait+Codable
//
//  Created by h.crane on 2021/06/22.
//
//

import Foundation
import Alamofire

// MARK: - Base API Protocol
protocol BaseAPIProtocol {
    associatedtype ResponseType

    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var headers: [String : String]? { get }
}

extension BaseAPIProtocol {

    var baseURL: URL {
        return try! "http://localhost:3000".asURL()
    }

    var headers: [String : String]? {
        return [
            "Content-Type": "application/json; charset=utf-8",
            "User-Agent": ""
        ]
    }
}

protocol BaseRequestProtocol: BaseAPIProtocol, URLRequestConvertible {
    var parameters: Parameters? { get }
    var encoding: URLEncoding { get }
}

extension BaseRequestProtocol {
    var encoding: URLEncoding {
        return URLEncoding.default
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.timeoutInterval = TimeInterval(30)
        if let params = parameters {
            urlRequest = try encoding.encode(urlRequest, with: params)
        }
        return urlRequest
    }
}
