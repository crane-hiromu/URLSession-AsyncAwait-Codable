# URLSession-AsyncAwait-Codable
URLSession + async/await + Codable

## Description
It's a demo.
You can call API by URLSession + async/await.

## Requirement
- Xcode13 Beta1
- MacOS Big Sur

## Usage
1. Download Xcode
2. Install Alamofire

## SetUp
Must read [Qiita](https://qiita.com/hcrane/items/288a5f89dc5b2dbec8f2)

## Code

```.swift
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
}
```

## Example

```.swift
async {
    let request = UserRequest()
    let response = try await APICliant.call(request)
    debugPrint(response)
}
```
