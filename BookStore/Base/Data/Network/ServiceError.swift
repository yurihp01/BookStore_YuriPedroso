import Foundation

public enum ServiceError: Error {
    case invalidResponse
    case invalidImageData
    case invalidStatusCode(statusCode: Int)
    case invalidData
    case invalidURL
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid Response"
        case .invalidURL:
            return "Invalid URL"
        case .invalidData:
            return "Invalid Data"
        case .invalidImageData:
            return "Invalid Image Data"
        case .invalidStatusCode(let statusCode):
            return "Invalid status code: \(statusCode)"
        }
    }
}
