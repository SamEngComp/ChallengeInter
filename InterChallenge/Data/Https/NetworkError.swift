import Foundation

enum NetworkError: Error {
    case noConnectivity
    case badRequest
    case serverError
}
