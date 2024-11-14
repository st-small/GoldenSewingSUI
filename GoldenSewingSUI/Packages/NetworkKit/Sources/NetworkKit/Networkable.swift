import Foundation

public protocol Networkable {
    func sendRequest<T: Decodable>(_ endpoint: EndPoint) async throws -> T
    func downloadImage(_ urlString: String) async throws -> Data
}

extension Networkable {
    fileprivate func createRequest(endPoint: EndPoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        
        // Adding query parameters
        urlComponents.queryItems = endPoint.queryParams?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // Handling path parameters
        var path = endPoint.path
        for (key, value) in endPoint.pathParams ?? [:] {
            path = path.replacingOccurrences(of: "{\(key)}", with: value)
        }
        urlComponents.path = path
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.header
        
        if let body = endPoint.body {
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(body)
        }
        
        return request
    }
}

public final class NetworkService: Networkable {
    public init() { }
    public func sendRequest<T: Decodable>(_ endpoint: EndPoint) async throws -> T {
        guard let urlRequest = createRequest(endPoint: endpoint) else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }

        if 200...299 ~= response.statusCode {
            guard let data = data as Data? else {
                throw NetworkError.unknown
            }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                throw error
            }
        } else {
            throw NetworkError.unexpectedStatusCode
        }
    }
    
    public func downloadImage(_ urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        return try Data(contentsOf: url)
    }
}
