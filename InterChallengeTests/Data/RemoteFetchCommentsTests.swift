import XCTest
@testable import InterChallenge

class RemoteFetchCommentsTests: XCTestCase {
    func test_fetch_should_call_httpClient_with_correct_url_and_one_userId(){
        let postId = 120
        let url = URL(string: "http://fake-url-test.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchComments(url: url, httpGetClient: httpClientSpy)
        sut.fetch(postId: postId){ _ in }
        XCTAssertEqual(url, httpClientSpy.url)
        XCTAssertEqual(postId, httpClientSpy.id)
    }
    
    func test_fetch_should_complete_with_error_if_client_completes_with_error() {
        let url = URL(string: "http://fake-url-test.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchComments(url: url, httpGetClient: httpClientSpy)
        let exp = expectation(description: "waiting")
        sut.fetch(postId: 0) { result in
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
        let sut = RemoteFetchComments(url: url, httpGetClient: httpClientSpy)
        let commentsSpy = [Comment(id: 12, postId: 100, name: "name", body: "body")]
        let exp = expectation(description: "waiting")
        sut.fetch(postId: 0) { result in
            switch result {
            case .success(let comments):
                XCTAssertEqual(comments, commentsSpy)
            case .failure(_):
                XCTFail()
            }
            exp.fulfill()
        }
        if let data = try? JSONEncoder().encode(commentsSpy.self) {
            httpClientSpy.callbackWithData(data)
        } else {
            XCTFail()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_fetch_should_complete_with_error_if_client_completes_with_invalid_data() {
        let url = URL(string: "http://fake-url-test.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchComments(url: url, httpGetClient: httpClientSpy)
        let exp = expectation(description: "waiting")
        sut.fetch(postId: 0) { result in
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

