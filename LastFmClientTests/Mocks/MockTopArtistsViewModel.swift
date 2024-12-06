//
//  MockTopArtistsViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 6.12.2024.
//

@testable import LastFmClient

class MockTopArtistsViewModel: TopArtistsViewModel {
    var mockFetchTopArtistsCalled = false
    var mockOnFetchTopArtists: (() -> Void)?
    var mockOnError: ((LastFmError) -> Void)?
    var mockOnLoadingStateChange: ((Bool) -> Void)?

    override func fetchTopArtists(userId: String) async {
        mockFetchTopArtistsCalled = true
        mockOnFetchTopArtists?()
    }
    
    override var onFetchTopArtists: (() -> Void)? {
        get { mockOnFetchTopArtists }
        set { mockOnFetchTopArtists = newValue }
    }
    
    override var onError: ((LastFmError) -> Void)? {
        get { mockOnError }
        set { mockOnError = newValue }
    }

    override var onLoadingStateChange: ((Bool) -> Void)? {
        get { mockOnLoadingStateChange }
        set { mockOnLoadingStateChange = newValue }
    }
    
    override func fetchMoreArtists(userId: String) async {
        // Simulate more fetching logic
    }
}
