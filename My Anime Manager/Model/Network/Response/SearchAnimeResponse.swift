//
//  SearchAnimeResponse.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation
// MARK: - SearchAnimeResponse

    struct SearchAnimeResponse: Codable {
        let requestHash: String
        let requestCached: Bool
        let requestCacheExpiry: Int
        let results: [Anime]
        let lastPage: Int

        enum CodingKeys: String, CodingKey {
            case requestHash = "request_hash"
            case requestCached = "request_cached"
            case requestCacheExpiry = "request_cache_expiry"
            case results
            case lastPage = "last_page"
        }
    }

    // MARK: - Result
    struct Anime: Codable {
        let malID: Int
        let url: String
        let imageURL: String
        let title: String
        let airing: Bool
        let synopsis, type: String
        let episodes: Int
        let score: Double
        // String to Date
        let startDate, endDate: String?
        let members: Int
        //
        let rated: Rated?

        enum CodingKeys: String, CodingKey {
            case malID = "mal_id"
            case url
            case imageURL = "image_url"
            case title, airing, synopsis, type, episodes, score
            case startDate = "start_date"
            case endDate = "end_date"
            case members, rated
        }
    }

    // MARK: - Rated
//    struct Rated: Codable {
//    }
enum Rated: String, Codable {
    case g = "G"
    case pg = "PG"
    case pg13 = "PG-13"
    case r = "R"
    case ratedR = "R+"
    case rx = "Rx"
}

enum TypeEnum: String, Codable {
    case movie = "Movie"
    case ona = "ONA"
    case ova = "OVA"
    case special = "Special"
    case tv = "TV"
}
