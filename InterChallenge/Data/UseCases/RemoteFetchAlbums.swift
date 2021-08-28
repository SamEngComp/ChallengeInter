import Foundation

class RemoteFetchAlbums: FetchAlbums {
    let url: URL
    let httpGetClient: HttpGetClient
    
    init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }
    
    func fetch(userId: Int, callback: @escaping (Result<[Album], DomainError>) -> Void) {
        httpGetClient.getAll(to: url, with: userId) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                guard let data = data,
                      let models: [Album] = try? JSONDecoder().decode([Album].self, from: data) else {
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
