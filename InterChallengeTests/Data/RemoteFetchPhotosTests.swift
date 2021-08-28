import XCTest
@testable import InterChallenge

class RemoteFetchPhotosTests: XCTestCase {
    func test_fetch_should_call_httpClient_with_correct_url_and_one_userId(){
        let albumId = 120
        let url = URL(string: "http://fake-url-test.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPhotos(url: url, httpGetClient: httpClientSpy)
        sut.fetch(albumId: albumId){ _ in }
        XCTAssertEqual(url, httpClientSpy.url)
        XCTAssertEqual(albumId, httpClientSpy.id)
    }
    
    func test_fetch_should_complete_with_error_if_client_completes_with_error() {
        let url = URL(string: "http://fake-url-test.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPhotos(url: url, httpGetClient: httpClientSpy)
        let exp = expectation(description: "waiting")
        sut.fetch(albumId: 0) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            exp.fulfill()
        }
        httpClientSpy.callbackWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    
    func test_fetch_should_complete_with_users_if_client_completes_with_valid_data() {
        let url = URL(string: "http://fake-url-test.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPhotos(url: url, httpGetClient: httpClientSpy)
        let photosSpy = [Photo(id: 0, albumId: 12, title: "tt", url: "test.com", thumbnailUrl: "image-test.com")]
        let exp = expectation(description: "waiting")
        sut.fetch(albumId: 0) { result in
            switch result {
            case .success(let photos):
                XCTAssertEqual(photos, photosSpy)
            case .failure(_):
                XCTFail()
            }
            exp.fulfill()
        }
        if let data = try? JSONEncoder().encode(photosSpy.self) {
            httpClientSpy.callbackWithData(data)
        } else {
            XCTFail()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_fetch_should_complete_with_error_if_client_completes_with_invalid_data() {
        let url = URL(string: "http://fake-url-test.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPhotos(url: url, httpGetClient: httpClientSpy)
        let exp = expectation(description: "waiting")
        sut.fetch(albumId: 0) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .unexpected)
            }
            exp.fulfill()
        }
        httpClientSpy.callbackWithData(Data())
        wait(for: [exp], timeout: 1)
    }
}

