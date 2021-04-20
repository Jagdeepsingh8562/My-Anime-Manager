//
//  TopAnimeResponse.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation
// MARK: - TopAnimeResponse
struct TopAnimeResponse: Codable {
    let requestHash: String
    let requestCached: Bool
    let requestCacheExpiry: Int
    let top: [TopAnime]

    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case requestCacheExpiry = "request_cache_expiry"
        case top
    }
}

// MARK: - Top
struct TopAnime: Codable {
    let malID, rank: Int
    let title: String
    let url: String
    let imageURL: String
    let type: TypeEnum
    let episodes: Int?
    let startDate: String
    let endDate: String?
    let members: Int
    let score: Double

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case rank, title, url
        case imageURL = "image_url"
        case type, episodes
        case startDate = "start_date"
        case endDate = "end_date"
        case members, score
    }
    enum TypeEnum: String, Codable {
        case movie = "Movie"
        case ona = "ONA"
        case ova = "OVA"
        case special = "Special"
        case tv = "TV"
    }
}
