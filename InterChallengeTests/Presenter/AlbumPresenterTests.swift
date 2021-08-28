import XCTest
@testable import InterChallenge

class AlbumPresenterTests: XCTestCase {
    func test_getAllAlbums_should_call_fetchUsers_and_pass_the_value_with_albums_to_viewDelegate() {
        let userId = 100
        let albums = [Album(id: 0, userId: 12, title: "title"),
                      Album(id: 1, userId: 10, title: "title")]
        let albumViewDelegateMock = AlbumViewDelegateMock()
        let remoteFetchAlbumsSpy = RemoteFetchAlbumsSpy()
        let sut = AlbumPresenter(service: remoteFetchAlbumsSpy)
        
        sut.setViewDelegate(viewDelegate: albumViewDelegateMock)
        sut.getAllAlbums(userId: userId)
        remoteFetchAlbumsSpy.callbackWithAlbums(albums)
        
        XCTAssertEqual(albums, albumViewDelegateMock.albums)
        XCTAssertEqual(userId, remoteFetchAlbumsSpy.userId)
        XCTAssertNil(albumViewDelegateMock.error)
    }
    
    func test_getAllAlbums_should_call_fetchUsers_and_pass_the_value_with_error_to_viewDelegate() {
        let userId = 100
        let albumViewDelegateMock = AlbumViewDelegateMock()
        let remoteFetchAlbumsSpy = RemoteFetchAlbumsSpy()
        let sut = AlbumPresenter(service: remoteFetchAlbumsSpy)
        
        sut.setViewDelegate(viewDelegate: albumViewDelegateMock)
        sut.getAllAlbums(userId: userId)
        remoteFetchAlbumsSpy.callbackWithError(.unexpected)
        
        XCTAssertEqual(albumViewDelegateMock.error, .unexpected)
        XCTAssertEqual(userId, remoteFetchAlbumsSpy.userId)
        XCTAssertNil(albumViewDelegateMock.albums)
    }

    func test_presentPhoto_should_call_didEnterPhoto_of_coordinator() {
        let albumId = 100
        let name = "name-test"
        let nextAlbumCoordinatorSpy = NextAlbumCoordinatorSpy()
        let remoteFetchAlbumsSpy = RemoteFetchAlbumsSpy()
        let sut = AlbumPresenter(service: remoteFetchAlbumsSpy)
        
        sut.setCoordinatorDelegate(coordinatorDelegate: nextAlbumCoordinatorSpy)
        sut.presetPhoto(albumId: albumId, name: name)
        
        XCTAssertEqual(albumId, nextAlbumCoordinatorSpy.albumId)
        XCTAssertEqual(name, nextAlbumCoordinatorSpy.name)
    }
}

extension AlbumPresenterTests {
    class RemoteFetchAlbumsSpy: FetchAlbums {
        var userId: Int?
        var callback: ((Result<[Album], DomainError>) -> Void)?
        
        func fetch(userId: Int, callback: @escaping (Result<[Album], DomainError>) -> Void) {
            self.userId = userId
            self.callback = callback
        }
        
        func callbackWithError(_ error: DomainError) {
            callback?(.failure(error))
        }

        func callbackWithAlbums(_ albums: [Album]) {
            callback?(.success(albums))
        }
    }
}

extension AlbumPresenterTests {
    class AlbumViewDelegateMock: AlbumViewDelegate {
        var albums: [Album]?
        var error: DomainError?
        
        func fillAlbums(albums: [Album]) {
            self.albums = albums
        }
        
        func errorPresent(error: DomainError) {
            self.error = error
        }
    }
}

extension AlbumPresenterTests {
    class NextAlbumCoordinatorSpy: NextAlbumCoordinatorDelegate {
        var albumId: Int?
        var name: String?
        
        func didEnterAlbum(with albumId: Int, by name: String) {
            self.albumId = albumId
            self.name = name
        }
    }
}
