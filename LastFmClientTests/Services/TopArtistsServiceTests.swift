//
//  TopArtistsServiceTests.swift
//  LastFmClient
//
//  Created by Emre Kuru on 5.12.2024.
//

import XCTest
import Testing
@testable import LastFmClient

final class TopArtistsServiceTests: XCTestCase {
    var mockTopItemsService: MockTopItemsService!
    var topArtistsService: TopArtistsService!
    
    override func setUp() {
        super.setUp()
        mockTopItemsService = MockTopItemsService()
        topArtistsService = TopArtistsService(networkService: mockTopItemsService)
    }

    override func tearDown() {
        mockTopItemsService = nil
        topArtistsService = nil
        super.tearDown()
    }

    func testFetchTopArtists_Success() async throws {
        // Given
        let mockResponse = TopArtistsResponse(topArtists: TopArtistsResponse.TopArtists(artists: [TopArtist(name: "Artist1", playcount: "123", image: [], rank: Rank(rank: "12")),
                                                                                                  TopArtist(name: "Artist2", playcount: "321", image: [], rank: Rank(rank: "52"))]))
        mockTopItemsService.responseData = mockResponse
        
        // When
        let artists = try await topArtistsService.fetchTopArtists(userId: "testUser", page: 1)
        
        // Then
        XCTAssertEqual(artists.count, 2)
        XCTAssertEqual(artists.first?.name, "Artist1")
    }
    
    func testFetchTopArtists_PaginationSuccess() async throws {
        // Given
        let mockResponse = TopArtistsResponse(topArtists: TopArtistsResponse.TopArtists(artists: [TopArtist(name: "Artist1", playcount: "123", image: [], rank: Rank(rank: "1"))]))
        mockTopItemsService.responseData = mockResponse
        
        // When
        let artistsPage1 = try await topArtistsService.fetchTopArtists(userId: "testUser", page: 1)
        let artistsPage2 = try await topArtistsService.fetchTopArtists(userId: "testUser", page: 2)
        
        // Then
        XCTAssertEqual(artistsPage1.count, 1)
        XCTAssertEqual(artistsPage2.count, 1)
        XCTAssertEqual(artistsPage1.first?.name, "Artist1")
    }
    
    func testFetchTopArtists_InvalidPageParameter() async {
        // Given
        mockTopItemsService.responseData = nil // Not relevant since it should fail before network call.
        
        // When/Then
        do {
            _ = try await topArtistsService.fetchTopArtists(userId: "testUser", page: -1)
            XCTFail("Expected an error for invalid page parameter but succeeded.")
        } catch let error as LastFmError {
            XCTAssertEqual(error, LastFmError.network(.invalidParameter("Page number must be greater than 0")))
        } catch {
            XCTFail("Expected NetworkError.invalidParameter but got \(error).")
        }
    }

    func testFetchTopArtists_LargeDataSet() async throws {
        // Given
        let largeList = (1...1000).map { TopArtist(name: "Artist\($0)", playcount: "\($0)", image: [], rank: Rank(rank: "\($0)")) }
        let mockResponse = TopArtistsResponse(topArtists: TopArtistsResponse.TopArtists(artists: largeList))
        mockTopItemsService.responseData = mockResponse
        
        // When
        let artists = try await topArtistsService.fetchTopArtists(userId: "testUser", page: 1)
        
        // Then
        XCTAssertEqual(artists.count, 1000)
        XCTAssertEqual(artists.last?.name, "Artist1000")
    }

    
    func testFetchTopArtists_InvalidURLFailure() async {
        // Given
        mockTopItemsService.error = NetworkError.invalidURL
        
        // When/Then
        do {
            _ = try await topArtistsService.fetchTopArtists(userId: "testUser", page: 1)
            XCTFail("Expected NetworkError.invalidURL but succeeded.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.invalidURL)
        } catch {
            XCTFail("Expected NetworkError.invalidURL but got \(error).")
        }
    }
    
    func testFetchTopArtists_DecodingErrorFailure() async {
        // Given
        mockTopItemsService.error = NetworkError.decodingError(NSError(domain: "", code: -1, userInfo: nil))
        
        // When/Then
        do {
            _ = try await topArtistsService.fetchTopArtists(userId: "testUser", page: 1)
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

    func testFetchTopArtists_APIErrorFailure() async {
        // Given
        let apiError = APIError(errorCode: 9) // Example error code
        let apiErrorResponse = APIErrorResponse(message: "Invalid session key - Please re-authenticate.", error: 9)
        mockTopItemsService.error = apiError
        
        // When/Then
        do {
            _ = try await topArtistsService.fetchTopArtists(userId: "testUser", page: 1)
            XCTFail("Expected APIError but succeeded.")
        } catch let error as APIError {
            XCTAssertEqual(error.message, apiErrorResponse.message)
        } catch {
            XCTFail("Expected APIError but got \(error).")
        }
    }
}
