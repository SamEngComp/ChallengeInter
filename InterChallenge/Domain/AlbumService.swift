import Alamofire
import Foundation

class AlbumService {
    func getAlbums(userId: Int, callback: @escaping ([Album]?)->Void) {
        AF.request("https://jsonplaceholder.typicode.com/albums?userId=\(userId)").validate().responseJSON { response in
            guard response.error == nil else {
                callback(nil)
                return
            }
            
            do {
                if let data = response.data {
                    let models = try JSONDecoder().decode([Album].self, from: data)
                    callback(models)
                }
            } catch {
                callback(nil)
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
        }
    }
}
