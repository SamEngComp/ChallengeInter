import XCTest
@testable import InterChallenge

class RemoteFetchUsersTests: XCTestCase {
    func test_fetch_should_call_httpClient_with_correct_url(){
        let url = URL(string: "http://fake-url-test.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchUsers(url: url, httpGetClient: httpClientSpy)
        sut.fetch(){ _ in }
        XCTAssertEqual(url, httpClientSpy.url)
    }
    
    func test_fetch_should_complete_with_error_if_client_completes_with_error() {
        let url = URL(string: "http://fake-url-test.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchUsers(url: url, httpGetClient: httpClientSpy)
        let exp = expectation(description: "waiting")
        sut.fetch() { result in
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
        let sut = RemoteFetchUsers(url: url, httpGetClient: httpClientSpy)
        let usersSpy = [User(id: 1,name:"name",username:"username",email:"email@fake.com",phone:"(88) 7729 2233")]
        let exp = expectation(description: "waiting")
        sut.fetch() { result in
            switch result {
            case .success(let users):
                XCTAssertEqual(users, usersSpy)
            case .failure(_):
                XCTFail()
            }
            exp.fulfill()
        }
        if let data = try? JSONEncoder().encode(usersSpy.self) {
            httpClientSpy.callbackWithData(data)
        } else {
            XCTFail()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_fetch_should_complete_with_error_if_client_completes_with_invalid_data() {
        let url = URL(string: "http://fake-url-test.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchUsers(url: url, httpGetClient: httpClientSpy)
        let exp = expectation(description: "waiting")
        sut.fetch() { result in
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

