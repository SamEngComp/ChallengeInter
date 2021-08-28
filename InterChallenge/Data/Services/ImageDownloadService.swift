import Alamofire
import Foundation

class ImageDownloadService {
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
