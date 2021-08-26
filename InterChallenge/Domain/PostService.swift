import Alamofire
import Foundation

class PostService {
    func getPosts(userId: Int, callback: @escaping ([Post]?) -> Void) {
        AF.request("https://jsonplaceholder.typicode.com/posts?userId=\(userId)").validate().responseJSON { response in
            guard response.error == nil else {
                callback(nil)
                return
            }
            
            do {
                if let data = response.data {
                    let models = try JSONDecoder().decode([Post].self, from: data)
                    callback(models)
                }
            } catch {
                callback(nil)
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
        }
    }
}
