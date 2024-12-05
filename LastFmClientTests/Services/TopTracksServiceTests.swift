//
//  TopTracksServiceTests.swift
//  LastFmClient
//
//  Created by Emre Kuru on 5.12.2024.
//

import XCTest
import Testing
@testable import LastFmClient

final class TopTracksServiceTests: XCTestCase {
    var mockTopItemsService: MockTopItemsService!
    var topTracksService: TopTracksService!
    
    override func setUp() {
        super.setUp()
        mockTopItemsService = MockTopItemsService()
        topTracksService = TopTracksService(networkService: mockTopItemsService)
    }

    override func tearDown() {
        mockTopItemsService = nil
        topTracksService = nil
        super.tearDown()
    }

    func testFetchTopTracks_Success() async throws {
        // Given
        let mockResponse = TopTracksResponse(topTracks: TopTracksResponse.TopTracks(tracks: [TopTrack(name: "Track1", playcount: "123", image: [], rank: Rank(rank: "12"), artist: PlayableArtist(name: "Artist1")),
                                                                                             TopTrack(name: "Track2", playcount: "321", image: [], rank: Rank(rank: "1"), artist: PlayableArtist(name: "Artist2"))]))
        mockTopItemsService.responseData = mockResponse
        
        // When
        let tracks = try await topTracksService.fetchTopTracks(userId: "testUser", page: 1)
        
        // Then
        XCTAssertEqual(tracks.count, 2)
        XCTAssertEqual(tracks.first?.name, "Track1")
    }
    
    func testFetchTopTracks_PaginationSuccess() async throws {
        // Given
        let mockResponse = TopTracksResponse(topTracks: TopTracksResponse.TopTracks(tracks: [TopTrack(name: "Track1", playcount: "123", image: [], rank: Rank(rank: "12"), artist: PlayableArtist(name: "Artist1"))]))
        mockTopItemsService.responseData = mockResponse
        
        // When
        let tracksPage1 = try await topTracksService.fetchTopTracks(userId: "testUser", page: 1)
        let tracksPage2 = try await topTracksService.fetchTopTracks(userId: "testUser", page: 2)
        
        // Then
        XCTAssertEqual(tracksPage1.count, 1)
        XCTAssertEqual(tracksPage2.count, 1)
        XCTAssertEqual(tracksPage1.first?.name, "Track1")
    }
    
    func testFetchTopTracks_InvalidPageParameter() async {
        // Given
        mockTopItemsService.responseData = nil // Not relevant since it should fail before network call.
        
        // When/Then
        do {
            _ = try await topTracksService.fetchTopTracks(userId: "testUser", page: -1)
            XCTFail("Expected an error for invalid page parameter but succeeded.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.invalidParameter("Page number must be greater than 0"))
        } catch {
            XCTFail("Expected NetworkError.invalidParameter but got \(error).")
        }
    }

    func testFetchTopTracks_LargeDataSet() async throws {
        // Given
        let largeList = (1...1000).map { TopTrack(name: "Track\($0)", playcount: "\($0)", image: [], rank: Rank(rank: "\($0)"), artist: PlayableArtist(name: "Artist\($0)")) }
        let mockResponse = TopTracksResponse(topTracks: TopTracksResponse.TopTracks(tracks: largeList))
        mockTopItemsService.responseData = mockResponse
        
        // When
        let tracks = try await topTracksService.fetchTopTracks(userId: "testUser", page: 1)
        
        // Then
        XCTAssertEqual(tracks.count, 1000)
        XCTAssertEqual(tracks.last?.name, "Track1000")
    }

    
    func testFetchTopTracks_InvalidURLFailure() async {
        // Given
        mockTopItemsService.error = NetworkError.invalidURL
        
        // When/Then
        do {
            _ = try await topTracksService.fetchTopTracks(userId: "testUser", page: 1)
            XCTFail("Expected NetworkError.invalidURL but succeeded.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.invalidURL)
        } catch {
            XCTFail("Expected NetworkError.invalidURL but got \(error).")
        }
    }
    
    func testFetchTopTracks_DecodingErrorFailure() async {
        // Given
        mockTopItemsService.error = NetworkError.decodingError(NSError(domain: "", code: -1, userInfo: nil))
        
        // When/Then
        do {
            _ = try await topTracksService.fetchTopTracks(userId: "testUser", page: 1)
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

    func testFetchTopTracks_APIErrorFailure() async {
        // Given
        let apiError = APIError(errorCode: 9) // Example error code
        let apiErrorResponse = APIErrorResponse(message: "Invalid session key - Please re-authenticate.", error: 9)
        mockTopItemsService.error = apiError
        
        // When/Then
        do {
            _ = try await topTracksService.fetchTopTracks(userId: "testUser", page: 1)
            XCTFail("Expected APIError but succeeded.")
        } catch let error as APIError {
            XCTAssertEqual(error.message, apiErrorResponse.message)
        } catch {
            XCTFail("Expected APIError but got \(error).")
        }
    }
}
