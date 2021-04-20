//
//  ErrorResponse.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let status: Int
    let type, message, error: String
}
