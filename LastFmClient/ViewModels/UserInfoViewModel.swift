//
//  UserInfoViewModel.swift
//  LastFmClient
//
//  Created by Emre Kuru on 8.07.2025.
//

import Foundation

final class UserInfoViewModel {
    private let userInfoService: UserInfoServiceProtocol

    // Bindings
    var onUserInfoUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private var userInfo: User? {
        didSet {
            onUserInfoUpdated?()
        }
    }

    // MARK: - Public Display Values
    var userName: String { userInfo?.name ?? "" }
    var scrobbles: String { userInfo?.playcount ?? "" }
    var artistCount: String { userInfo?.artist_count ?? "" }
    var albumCount: String { userInfo?.album_count ?? "" }
    var trackCount: String { userInfo?.track_count ?? "" }

    
    init(userInfoService: UserInfoServiceProtocol) {
        self.userInfoService = userInfoService
    }
    
    func fetchUserInfo(userId: String) async throws {
        do {
            let userInfo = try await userInfoService.fetchUserInfo(userId: userId)
            self.userInfo = userInfo
        } catch {
            onError?(error)
        }
    }
}
