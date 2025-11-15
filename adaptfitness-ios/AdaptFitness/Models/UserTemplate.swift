//
//  User.swift
//  AdaptFitness
//
//  Created by csuftitan on 10/13/25.
//
import SwiftUI

struct UserTemplate: Codable, Identifiable {
    var id: String
    var email: String
    var token: String?
    var lastLogin: Date?
    var loginStreak: Int?
}

extension UserTemplate {
    static let exampleUser = UserTemplate(
        id: UUID().uuidString,
        email: "user@example.com",
        token: "abc123",
        lastLogin: Date(),
        loginStreak: 5
    )
}
