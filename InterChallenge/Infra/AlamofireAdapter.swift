import Alamofire
import Foundation

class AlamofireAdapter: HttpGetClient {
    
    public func getAll(to url: URL, with id: Int?, callback: @escaping (Result<Data?, NetworkError>) -> Void) {
        AF.request(id == nil ? url : url.absoluteString+"\(id!)").validate().responseData { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else { return callback(.failure(.noConnectivity)) }
            switch dataResponse.result {
            case .failure: callback(.failure(.noConnectivity))
            case .success(let data):
                switch statusCode {
                case 204:
                    callback(.success(nil))
                case 200...299:
                    callback(.success(data))
                case 400...499:
                    callback(.failure(.badRequest))
                case 500...599:
                    callback(.failure(.serverError))
                default:
                    callback(.failure(.noConnectivity))
                }
            }
        }
    }
    
}

extension AlamofireAdapter {
    static func downloadPhoto(url: String, callback: @escaping (Data?) -> Void) {
        AF.download(url).responseData { response in
            switch response.result {
            case .success(let data):
                callback(data)
            default:
                callback(nil)
                break
            }
        }
    }
}
