//
//  TopArtistViewModelTests.swift
//  LastFmClient
//
//  Created by Emre Kuru on 6.12.2024.
//

import XCTest
@testable import LastFmClient

class TopArtistViewModelTests: XCTestCase {
    var viewModel: TopArtistViewModel!
    var mockArtistService: MockArtistService!
    
    override func setUp() {
        super.setUp()
        mockArtistService = MockArtistService()
        let artist = TopArtist(name: "Test Artist", playcount: "2000", image: [Image(size: "medium", url: "http://test.com/image.jpg")], rank: Rank(rank: "1"))
        
        viewModel = TopArtistViewModel(artist: artist, artistService: mockArtistService)
    }

    override func tearDown() {
        viewModel = nil
        mockArtistService = nil
        super.tearDown()
    }
    
    // MARK: - Test Computed Properties
    func testFormattedRank() {
        XCTAssertEqual(viewModel.formattedRank, "1.")
    }

    func testFormattedPlaycount() {
        XCTAssertEqual(viewModel.formattedPlaycount, "2.000")
    }

    func testImageURL() {
        XCTAssertEqual(viewModel.imageURL?.absoluteString, "http://test.com/image.jpg")
    }
    
    func testWrongRank() {
        let artist = TopArtist(name: "Test Artist", playcount: "2000", image: [Image(size: "medium", url: "http://test.com/image.jpg")], rank: Rank(rank: "abc"))
        
        let viewModel = TopArtistViewModel(artist: artist, artistService: mockArtistService)
        
        XCTAssertEqual(viewModel.formattedRank, "0.")
    }
    
    func testWrongPlaycount() {
        let artist = TopArtist(name: "Test Artist", playcount: "abc", image: [Image(size: "medium", url: "http://test.com/image.jpg")], rank: Rank(rank: "1"))
        
        let viewModel = TopArtistViewModel(artist: artist, artistService: mockArtistService)
        
        XCTAssertEqual(viewModel.formattedPlaycount, "0")
    }

    // MARK: - Test fetchArtistInfo Success
    func testFetchArtistInfo_Success() async {
        // Given
        let expectedArtistInfo = Artist(name: "Test Artist", image: [Image(size: "medium", url: "http://test.com/success-image.jpg")])
        mockArtistService.artistInfo = expectedArtistInfo
        
        let expectation = self.expectation(description: "onImageUpdate should be called")
        viewModel.onImageUpdate = {
            expectation.fulfill()
        }

        // When
        await viewModel.fetchArtistInfo(userId: "user123")

        // Then
        await fulfillment(of: [expectation], timeout: 2)
        XCTAssertEqual(viewModel.artistInfo?.name, "Test Artist")
    }

    // MARK: - Test fetchArtistInfo Error Handling
    func testFetchArtistInfo_Error() async {
        // Given
        mockArtistService.shouldReturnError = true

        let expectation = self.expectation(description: "onImageUpdate should NOT be called")
        expectation.isInverted = true

        viewModel.onImageUpdate = {
            expectation.fulfill()
        }

        // When
        await viewModel.fetchArtistInfo(userId: "user123")
        
        // Then
        await fulfillment(of: [expectation], timeout: 2)
        XCTAssertNil(viewModel.artistInfo)
    }

    // MARK: - Test if redundant requests are prevented
    func testFetchArtistInfo_PreventsRedundantRequests() async {
        // Given
        let expectedArtistInfo = Artist(name: "Test Artist", image: [Image(size: "medium", url: "http://test.com/success-image.jpg")])
        mockArtistService.artistInfo = expectedArtistInfo

        // Simulate multiple calls
        Task {
            await viewModel.fetchArtistInfo(userId: "user123")
        }

        Task {
            await viewModel.fetchArtistInfo(userId: "user123")
        }
        
        XCTAssertEqual(viewModel.artistInfo?.name, "Test Artist")
    }
}

