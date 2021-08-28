import Foundation

class RemoteFetchPhotos: FetchPhotos {
    let url: URL
    let httpGetClient: HttpGetClient
    
    init(url: URL, httpGetClient: HttpGetClient) {
        self.url = url
        self.httpGetClient = httpGetClient
    }
    
    func fetch(albumId: Int, callback: @escaping (Result<[Photo], DomainError>) -> Void) {
        httpGetClient.getAll(to: url, with: albumId) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                guard let data = data,
                      let models: [Photo] = try? JSONDecoder().decode([Photo].self, from: data) else {
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
