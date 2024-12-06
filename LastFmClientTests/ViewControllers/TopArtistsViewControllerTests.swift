//
//  TopArtistsViewControllerTests.swift
//  LastFmClient
//
//  Created by Emre Kuru on 6.12.2024.
//

import XCTest
@testable import LastFmClient

class TopArtistsViewControllerTests: XCTestCase {
    
    var viewController: TopArtistsViewController!
    var mockViewModel: MockTopArtistsViewModel!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockTopArtistsViewModel(topArtistsService: MockTopArtistsService(), artistService: MockArtistService())
        viewController = TopArtistsViewController(viewModel: mockViewModel)
        
        // Load the viewController's view to trigger viewDidLoad
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    // MARK: - Test View Did Load
    func testViewDidLoad_CallsFetchTopArtists() {
        
        let expectation = XCTestExpectation(description: "ViewModel fetchTopArtists called")
        
        mockViewModel.mockOnFetchTopArtists = {
            DispatchQueue.main.async {
                expectation.fulfill()
            }
        }
        // Force `viewDidLoad`
        _ = viewController.view
        
        // Wait for the expectation
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(mockViewModel.mockFetchTopArtistsCalled, "ViewModel's fetchTopArtists should have been triggered.")
    }
    
    // MARK: - Test Error Handling
    func testOnErrorTriggered() {
        let errorExpectation = expectation(description: "Error alert should be triggered")
        let expectedError = LastFmError.other("Unknown error")
        // Ensure closure is set
        mockViewModel.mockOnError = { error in
            XCTAssertEqual(error, expectedError)
            errorExpectation.fulfill()
        }

        // Simulate error
        mockViewModel.mockOnError?(LastFmError.other("Unknown error"))
        
        wait(for: [errorExpectation], timeout: 1)
    }
    
    // MARK: - Test Loading State
    func testLoadingStateChange() {
        let expectation = self.expectation(description: "onLoadingStateChange should be called twice")
        expectation.expectedFulfillmentCount = 2
        var loadingStates = [Bool]()
        
        mockViewModel.mockOnLoadingStateChange = { isLoading in
            loadingStates.append(isLoading)
            expectation.fulfill()
        }
        
        mockViewModel.mockOnLoadingStateChange?(true)
        mockViewModel.mockOnLoadingStateChange?(false)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(loadingStates, [true, false])
    }
    
    // MARK: - Test ScrollView Did Scroll
    func testScrollViewDidScroll_TriggersFetchMoreArtists() {
        let fetchMoreExpectation = expectation(description: "fetchMoreArtists should be triggered")
        
        mockViewModel.mockOnFetchTopArtists = {
            fetchMoreExpectation.fulfill()
        }
        
        // Simulate scroll
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: 0, height: 2000) // Simulate scrollable area
        scrollView.frame = CGRect(x: 0, y: 0, width: 375, height: 700)
        scrollView.contentOffset.y = 2000
        
        viewController.scrollViewDidScroll(scrollView)
        
        wait(for: [fetchMoreExpectation], timeout: 1)
    }
}
