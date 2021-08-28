import Foundation

class RemoteFetchComments: FetchComments {
    let url: URL
    let httpGetClient: HttpGetClient
    
    init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }
    
    func fetch(postId: Int, callback: @escaping (Result<[Comment], DomainError>) -> Void) {
        httpGetClient.getAll(to: url, with: postId) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                guard let data = data,
                      let models: [Comment] = try? JSONDecoder().decode([Comment].self, from: data) else {
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

