import Foundation
@testable import InterChallenge

class HttpClientSpy: HttpGetClient {
    
    var url: URL?
    var id: Int?
    var callback: ((Result<Data?, NetworkError>) -> Void)?

    func getAll(to url: URL, with id: Int?, callback: @escaping (Result<Data?, NetworkError>) -> Void) {
        self.url = url
        self.id = id
        self.callback = callback
    }

    func callbackWithError(_ error: NetworkError) {
        callback?(.failure(error))
    }

    func callbackWithData(_ data: Data) {
        callback?(.success(data))
    }
}
