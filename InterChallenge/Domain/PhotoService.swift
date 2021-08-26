import Alamofire
import Foundation
import UIKit

class PhotoService {
    func getPhotos(albumId: Int, callcack: @escaping ([Photo]?) -> Void) {
        AF.request("https://jsonplaceholder.typicode.com/photos?albumId=\(albumId)").validate().responseJSON { response in
            guard response.error == nil else {
                callcack(nil)
                return
            }
            
            do {
                if let data = response.data {
                    let models = try JSONDecoder().decode([Photo].self, from: data)
                    callcack(models)
                }
            } catch {
                callcack(nil)
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
        }
    }
    
    func dowloadPhoto(url: String, callback: @escaping (UIImage?) -> Void) {
        AF.download(url).responseData { response in
            switch response.result {
            case .success(let data):
                callback(UIImage(data: data))
            default:
                callback(nil)
                break
            }
        }
    }
}
