import Combine
import UIKit

// MARK: - Enum HTTP
public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

// MARK: - Networking Class
public class Networking {
    public func getImage(from url: String) -> AnyPublisher<UIImage, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: ServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw ServiceError.invalidResponse
                }
                
                guard let image = UIImage(data: output.data) else {
                    throw ServiceError.invalidImageData
                }
                
                return image
            }
            .eraseToAnyPublisher()
    }
    
    public func performRequest<T: Decodable>(bookstoreURL: BookstoreURL, method: HTTPMethod, headers: [String: String]? = nil, body: Data? = nil) -> AnyPublisher<T, Error> {
        guard let url = URL(string: bookstoreURL.url) else {
            return Fail(error: ServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            request.httpBody = body
        }
        
        return getPublisher(with: request)
    }
    
    public func performRequest<T: Decodable>(bookstoreURL: BookstoreURL, method: HTTPMethod, headers: [String: String]? = nil, body: Data? = nil, page: Int?) -> AnyPublisher<T, Error> {
        var url = bookstoreURL.url
        if let page = page {
            url.append("?page=\(page)&limit=10")
        }
        guard let url = URL(string: url) else {
            return Fail(error: ServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            request.httpBody = body
        }
        
        return getPublisher(with: request)
    }
}

// MARK: - Private Ext Networking
private extension Networking {
    func getPublisher<T: Decodable>(with request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { [weak self] output in
                try self?.validateData(output)
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func validateData(_ output: URLSession.DataTaskPublisher.Output) throws {
        if output.data.isEmpty {
            throw ServiceError.invalidData
        }
        
        if output.response as? HTTPURLResponse == nil {
            throw ServiceError.invalidResponse
        }
        
        if let response = output.response as? HTTPURLResponse, response.statusCode != 200 {
            throw ServiceError.invalidStatusCode(statusCode: response.statusCode)
        }
    }
}
