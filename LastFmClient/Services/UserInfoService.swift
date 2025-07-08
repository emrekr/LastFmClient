//
//  UserInfoService.swift
//  LastFmClient
//
//  Created by Emre Kuru on 8.07.2025.
//

protocol UserInfoServiceProtocol {
    func fetchUserInfo(userId: String) async throws -> User
}

class UserInfoService: UserInfoServiceProtocol {
    private let userService: UserServiceProtocol
    
    init(networkService: UserServiceProtocol = UserService()) {
        self.userService = networkService
    }
    
    func fetchUserInfo(userId: String) async throws -> User {
        let response: UserResponse = try await userService.fetch(endpoint: .userInfo(username: userId))
        return response.user
    }
}
