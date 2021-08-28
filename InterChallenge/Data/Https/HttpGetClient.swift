import Foundation

protocol HttpGetClient {
    func getAll(to url: URL, with id: Int?, callback:@escaping (Result<Data?, NetworkError>) -> Void)
}
