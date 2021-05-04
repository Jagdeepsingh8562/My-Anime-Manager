//
//  RecommendationsAnimeResponse.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation

struct RecommendationsAnimeResponse: Codable {
    let recommendations: [Recommendation]

    enum CodingKeys: String, CodingKey {
        case recommendations
    }
}

// MARK: - Recommendation
struct Recommendation: Codable {
    let malID: Int
    let url: String
    let imageURL: String
    let recommendationURL: String
    let title: String
    let recommendationCount: Int

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url
        case imageURL = "image_url"
        case recommendationURL = "recommendation_url"
        case title
        case recommendationCount = "recommendation_count"
    }
}
