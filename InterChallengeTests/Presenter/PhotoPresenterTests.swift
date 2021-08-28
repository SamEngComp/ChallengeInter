import XCTest
@testable import InterChallenge

class PhotoPresenterTests: XCTestCase {
    func test_getAllPhotos_should_call_fetchUsers_and_pass_the_value_with_photos_to_viewDelegate() {
        let albumId = 100
        let photos = [Photo(id: 0, albumId: 11, title: "title", url: "image.com", thumbnailUrl: "image.com"),
                     Photo(id: 1, albumId: 12, title: "title", url: "image.com", thumbnailUrl: "image.com")]
        let photoViewDelegateMock = PhotoViewDelegateMock()
        let remotePhotoServiceSpy = RemotePhotoServiceSpy()
        let sut = PhotoPresenter(service: remotePhotoServiceSpy)

        sut.setViewDelegate(viewDelegate: photoViewDelegateMock)
        sut.getAllPhotos(albumId: albumId)
        remotePhotoServiceSpy.callbackWithPhotos(photos)

        XCTAssertEqual(photos, photoViewDelegateMock.photos)
        XCTAssertEqual(albumId, remotePhotoServiceSpy.albumId)
        XCTAssertNil(photoViewDelegateMock.error)
    }

    func test_getAllPhotos_should_call_fetchUsers_and_pass_the_value_with_error_to_viewDelegate() {
        let albumId = 100
        let photoViewDelegateMock = PhotoViewDelegateMock()
        let remotePhotoServiceSpy = RemotePhotoServiceSpy()
        let sut = PhotoPresenter(service: remotePhotoServiceSpy)

        sut.setViewDelegate(viewDelegate: photoViewDelegateMock)
        sut.getAllPhotos(albumId: albumId)
        remotePhotoServiceSpy.callbackWithError(.unexpected)

        XCTAssertEqual(photoViewDelegateMock.error, .unexpected)
        XCTAssertEqual(albumId, remotePhotoServiceSpy.albumId)
        XCTAssertNil(photoViewDelegateMock.photos)
    }

    func test_presentAlbum_should_call_didEnterAlbum_of_coordinator() {
        let imageUrl = "image.com"
        let name = "name-test"
        let nextPhotoCoordinatorSpy = NextPhotoCoordinatorSpy()
        let remotePhotoServiceSpy = RemotePhotoServiceSpy()
        let sut = PhotoPresenter(service: remotePhotoServiceSpy)

        sut.setCoordinatorDelegate(coordinatorDelegate: nextPhotoCoordinatorSpy)
        sut.presentPhoto(imageUrl: imageUrl, name: name)

        XCTAssertEqual(imageUrl, nextPhotoCoordinatorSpy.imageUrl)
        XCTAssertEqual(name, nextPhotoCoordinatorSpy.name)
    }
}

extension PhotoPresenterTests {
    class RemotePhotoServiceSpy: PhotoService {
        var albumId: Int?
        var callback: ((Result<[Photo], DomainError>) -> Void)?
        
        func fetchPhotos(albumId: Int, callback: @escaping (Result<[Photo], DomainError>) -> Void) {
            self.albumId = albumId
            self.callback = callback
        }
        
        func callbackWithError(_ error: DomainError) {
            callback?(.failure(error))
        }

        func callbackWithPhotos(_ photos: [Photo]) {
            callback?(.success(photos))
        }
    }
}

extension PhotoPresenterTests {
    class PhotoViewDelegateMock: PhotoViewDelegate {
        var photos: [Photo]?
        var error: DomainError?
        
        func fillPhotos(photos: [Photo]) {
            self.photos = photos
        }
        
        func errorPresent(error: DomainError) {
            self.error = error
        }
    }
}

extension PhotoPresenterTests {
    class NextPhotoCoordinatorSpy: NextPhotoCoordinatorDelegate {
        var imageUrl: String?
        var name: String?
        
        func didEnterPhoto(with imageUrl: String, by name: String) {
            self.imageUrl = imageUrl
            self.name = name
        }
    }
}
