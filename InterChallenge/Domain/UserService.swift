import Alamofire
import Foundation

class UserService {
    func getUsers(callback: @escaping ([User]?) -> Void) {
        AF.request("https://jsonplaceholder.typicode.com/users").validate().responseJSON { response in
            guard response.error == nil else {
                callback(nil)
                return
            }
            
            do {
                if let data = response.data {
                    let models = try JSONDecoder().decode([User].self, from: data)
                    callback(models)
                }
            } catch {
                callback(nil)
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
        }

    }
}
