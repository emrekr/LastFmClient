//
//  TopArtistsViewModelTests.swift
//  LastFmClient
//
//  Created by Emre Kuru on 6.12.2024.
//

import XCTest
@testable import LastFmClient

class TopArtistsViewModelTests: XCTestCase {
    
    var viewModel: TopArtistsViewModel!
    var mockTopArtistsService: MockTopArtistsService!
    var mockArtistService: MockArtistService!
    
    override func setUp() {
        super.setUp()
        mockTopArtistsService = MockTopArtistsService()
        mockArtistService = MockArtistService()
        viewModel = TopArtistsViewModel(topArtistsService: mockTopArtistsService, artistService: mockArtistService)
    }
    
    func testFetchTopArtists_Success() async {
        // Given
        let expectedArtists = [TopArtist(name: "Artist1", playcount: "1000", image: [], rank: Rank(rank: "1"))]
        mockTopArtistsService.shouldReturnArtists = expectedArtists
        
        let expectation = self.expectation(description: "onFetchTopArtists should be called")
        viewModel.onFetchTopArtists = {
            expectation.fulfill()
        }
        
        // When
        await viewModel.fetchTopArtists(userId: "testUser")
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(viewModel.numberOfRowsInSection, 1)
    }
    
    func testFetchArtistInfo_Success() async {
        // Given
        let artist = TopArtist(name: "Artist1", playcount: "1000", image: [], rank: Rank(rank: "1"))
        let mockArtistInfo = Artist(name: "Artist1", image: [])
        mockArtistService.artistInfo = mockArtistInfo
        let artistViewModel = TopArtistViewModel(artist: artist, artistService: mockArtistService)

        let expectation = self.expectation(description: "onImageUpdate should be called")
        artistViewModel.onImageUpdate = {
            expectation.fulfill()
        }
        
        // When
        await artistViewModel.fetchArtistInfo(userId: "testUser")
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertNotNil(artistViewModel.artistInfo)
    }
    
    func testFetchTopArtists_Error() async {
        // Given
        mockTopArtistsService.shouldReturnError = true
        
        let expectation = self.expectation(description: "onError should be called")
        viewModel.onError = { error in
            XCTAssertEqual(error, LastFmError.api(.unknownError))
            expectation.fulfill()
        }
        
        // When
        await viewModel.fetchTopArtists(userId: "testUser")
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func testFetchMoreArtists_Success() async {
        // Given
        let expectedArtists = [TopArtist(name: "Artist1", playcount: "1000", image: [], rank: Rank(rank: "1"))]
        mockTopArtistsService.shouldReturnArtists = expectedArtists
        let expectation = self.expectation(description: "onFetchTopArtists should be called")
        viewModel.onFetchTopArtists = {
            expectation.fulfill()
        }
        
        // When
        await viewModel.fetchMoreArtists(userId: "testUser")
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(viewModel.numberOfRowsInSection, 1) // Artists should be added
    }

    func testFetchTopArtists_EmptyState() async {
        // Given
        mockTopArtistsService.shouldReturnArtists = []
        let expectation = self.expectation(description: "onFetchTopArtists should be called")
        viewModel.onFetchTopArtists = {
            expectation.fulfill()
        }
        
        // When
        await viewModel.fetchTopArtists(userId: "testUser")
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(viewModel.numberOfRowsInSection, 0)
    }
    
    func testLoadingState() async {
        // Given
        let expectation = self.expectation(description: "onLoadingStateChange should be called twice")
        expectation.expectedFulfillmentCount = 2
        var loadingStates = [Bool]()
        viewModel.onLoadingStateChange = { isLoading in
            loadingStates.append(isLoading)
            expectation.fulfill()
        }
        
        // When
        await viewModel.fetchTopArtists(userId: "testUser")
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(loadingStates, [true, false])
    }
    
    func testMoreArtists_LoadingState() async {
        // Given
        let expectation = self.expectation(description: "onLoadingStateChange should be called twice")
        expectation.expectedFulfillmentCount = 2
        var loadingStates = [Bool]()
        viewModel.onLoadingStateChange = { isLoading in
            loadingStates.append(isLoading)
            expectation.fulfill()
        }
        
        // When
        await viewModel.fetchMoreArtists(userId: "testUser")
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(loadingStates, [true, false])
    }
    
    func testOnFetchTopArtistsCallbackOrder() async {
        // Given
        let expectation = self.expectation(description: "onFetchTopArtists should be called")
        var callbackCalled = false
        viewModel.onFetchTopArtists = {
            callbackCalled = true
            expectation.fulfill()
        }
        
        // When
        await viewModel.fetchTopArtists(userId: "testUser")
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(callbackCalled)
    }
    
    func testHandleError() async {
        // Given
        let expectedError = NSError(domain: "unknown", code: 1001)
        mockTopArtistsService.shouldReturnError = true
        mockTopArtistsService.error = expectedError
        
        let expectation = self.expectation(description: "onError should be called with the correct error")
        viewModel.onError = { error in
            XCTAssertEqual(error, LastFmError.other(expectedError.localizedDescription))
            expectation.fulfill()
        }
        
        // When
        await viewModel.fetchTopArtists(userId: "testUser")
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func testFetchArtists_ConcurrentRequests_ShouldHandleSingleRequest() async {
        // Given
        let expectedArtists = [TopArtist(name: "Artist1", playcount: "1000", image: [], rank: Rank(rank: "1"))]
        mockTopArtistsService.shouldReturnArtists = expectedArtists

        let expectation = self.expectation(description: "onFetchTopArtists should only run once")
        expectation.expectedFulfillmentCount = 1 // Expect this to run once regardless of multiple requests

        viewModel.onFetchTopArtists = {
            expectation.fulfill()
        }

        // When: Trigger the requests at the same time
        let task1 = Task {
            await viewModel.fetchTopArtists(userId: "testUser")
        }

        let task2 = Task {
            await viewModel.fetchTopArtists(userId: "testUser")
        }

        // Wait for expectations
        await fulfillment(of: [expectation], timeout: 2)

        // Cleanup
        task1.cancel()
        task2.cancel()

        // Then: Ensure we only triggered fetching once
        XCTAssertEqual(viewModel.numberOfRowsInSection, 1) // Only one fetch should happen
    }


}
