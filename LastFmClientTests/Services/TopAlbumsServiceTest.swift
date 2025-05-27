//
//  TopAlbumsServiceTests.swift
//  LastFmClient
//
//  Created by Emre Kuru on 5.12.2024.
//

import XCTest
import Testing
@testable import LastFmClient

final class TopAlbumsServiceTests: XCTestCase {
    var mockTopItemsService: MockTopItemsService!
    var topAlbumsService: TopAlbumsService!
    
    override func setUp() {
        super.setUp()
        mockTopItemsService = MockTopItemsService()
        topAlbumsService = TopAlbumsService(networkService: mockTopItemsService)
    }

    override func tearDown() {
        mockTopItemsService = nil
        topAlbumsService = nil
        super.tearDown()
    }

    func testFetchTopAlbums_Success() async throws {
        // Given
        let mockResponse = TopAlbumsResponse(topAlbums: TopAlbumsResponse.TopAlbums(albums: [TopAlbum(name: "Album1", playcount: "123", image: [], rank: Rank(rank: "1"), artist: PlayableArtist(name: "Artist1")),
                                                                                             TopAlbum(name: "Album2", playcount: "321", image: [], rank: Rank(rank: "21"), artist: PlayableArtist(name: "Artist2"))]))
        mockTopItemsService.responseData = mockResponse
        
        // When
        let albums = try await topAlbumsService.fetchTopAlbums(userId: "testUser", page: 1)
        
        // Then
        XCTAssertEqual(albums.count, 2)
        XCTAssertEqual(albums.first?.name, "Album1")
    }
    
    func testFetchTopAlbums_PaginationSuccess() async throws {
        // Given
        let mockResponse = TopAlbumsResponse(topAlbums: TopAlbumsResponse.TopAlbums(albums: [TopAlbum(name: "Album1", playcount: "123", image: [], rank: Rank(rank: "1"), artist: PlayableArtist(name: "Artist1"))]))
        mockTopItemsService.responseData = mockResponse
        
        // When
        let albumsPage1 = try await topAlbumsService.fetchTopAlbums(userId: "testUser", page: 1)
        let albumsPage2 = try await topAlbumsService.fetchTopAlbums(userId: "testUser", page: 2)
        
        // Then
        XCTAssertEqual(albumsPage1.count, 1)
        XCTAssertEqual(albumsPage2.count, 1)
        XCTAssertEqual(albumsPage1.first?.name, "Album1")
    }
    
    func testFetchTopAlbums_InvalidPageParameter() async {
        // Given
        mockTopItemsService.responseData = nil // Not relevant since it should fail before network call.
        
        // When/Then
        do {
            _ = try await topAlbumsService.fetchTopAlbums(userId: "testUser", page: -1)
            XCTFail("Expected an error for invalid page parameter but succeeded.")
        } catch let error as LastFmError {
            XCTAssertEqual(error, LastFmError.network(.invalidParameter("Page number must be greater than 0")))
        } catch {
            XCTFail("Expected NetworkError.invalidParameter but got \(error).")
        }
    }

    func testFetchTopAlbums_LargeDataSet() async throws {
        // Given
        let largeList = (1...1000).map { TopAlbum(name: "Album\($0)", playcount: "\($0)", image: [], rank: Rank(rank: "\($0)"), artist: PlayableArtist(name: "Artist\($0)")) }
        let mockResponse = TopAlbumsResponse(topAlbums: TopAlbumsResponse.TopAlbums(albums: largeList))
        mockTopItemsService.responseData = mockResponse
        
        // When
        let albums = try await topAlbumsService.fetchTopAlbums(userId: "testUser", page: 1)
        
        // Then
        XCTAssertEqual(albums.count, 1000)
        XCTAssertEqual(albums.last?.name, "Album1000")
    }

    
    func testFetchTopAlbums_InvalidURLFailure() async {
        // Given
        mockTopItemsService.error = NetworkError.invalidURL
        
        // When/Then
        do {
            _ = try await topAlbumsService.fetchTopAlbums(userId: "testUser", page: 1)
            XCTFail("Expected NetworkError.invalidURL but succeeded.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.invalidURL)
        } catch {
            XCTFail("Expected NetworkError.invalidURL but got \(error).")
        }
    }
    
    func testFetchTopAlbums_DecodingErrorFailure() async {
        // Given
        mockTopItemsService.error = NetworkError.decodingError(NSError(domain: "", code: -1, userInfo: nil))
        
        // When/Then
        do {
            _ = try await topAlbumsService.fetchTopAlbums(userId: "testUser", page: 1)
            XCTFail("Expected NetworkError.decodingError but succeeded.")
        } catch let error as NetworkError {
            switch error {
            case .decodingError:
                XCTAssertTrue(true) // Test succeeds because decoding error is caught
            default:
                XCTFail("Expected decodingError but got \(error).")
            }
        } catch {
            XCTFail("Expected NetworkError.decodingError but got \(error).")
        }
    }

    func testFetchTopAlbums_APIErrorFailure() async {
        // Given
        let apiError = APIError(errorCode: 9) // Example error code
        let apiErrorResponse = APIErrorResponse(message: "Invalid session key - Please re-authenticate.", error: 9)
        mockTopItemsService.error = apiError
        
        // When/Then
        do {
            _ = try await topAlbumsService.fetchTopAlbums(userId: "testUser", page: 1)
            XCTFail("Expected APIError but succeeded.")
        } catch let error as APIError {
            XCTAssertEqual(error.message, apiErrorResponse.message)
        } catch {
            XCTFail("Expected APIError but got \(error).")
        }
    }
}
