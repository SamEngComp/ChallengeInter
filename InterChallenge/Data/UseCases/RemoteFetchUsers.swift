import Foundation

class RemoteFetchUsers: FetchUsers {
    let url: URL
    let httpGetClient: HttpGetClient

    init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }
    
    func fetch(callback: @escaping (Result<[User], DomainError>) -> Void) {
        httpGetClient.getAll(to: url, with: nil) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                guard let data = data,
                      let models: [User] = try? JSONDecoder().decode([User].self, from: data) else {
                    callback(.failure(.unexpected))
                    return
                }
                callback(.success(models))
            case .failure(let error):
                switch error {
                default:
                    callback(.failure(.unexpected))
                }
            }
        }
    }
}


