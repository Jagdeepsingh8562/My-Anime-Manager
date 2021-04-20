//
//  SeasonalAnimeReponse.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation


// MARK: - SeasonResponse
struct SeasonResponse: Codable {
    let requestHash: String
    let requestCached: Bool
    let requestCacheExpiry: Int
    let seasonName: String
    let seasonYear: Int?
    let anime: [SeasonAnime]

    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case requestCacheExpiry = "request_cache_expiry"
        case seasonName = "season_name"
        case seasonYear = "season_year"
        case anime
    }
}

// MARK: - Anime
struct SeasonAnime: Codable {
    let malID: Int
    let url: String
    let title: String
    let imageURL: String
    let synopsis: String
    let type: AnimeType
    let airingStart: String?
    let episodes: Int?
    let members: Int
    let genres: [Genre]
    let source: Source
    let producers: [Genre]
    let score: Double?
    let licensors: [String]
    let r18, kids, continuing: Bool

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url, title
        case imageURL = "image_url"
        case synopsis, type
        case airingStart = "airing_start"
        case episodes, members, genres, source, producers, score, licensors, r18, kids, continuing
    }
}




enum Source: String, Codable {
    case book = "Book"
    case cardGame = "Card game"
    case empty = "-"
    case game = "Game"
    case lightNovel = "Light novel"
    case manga = "Manga"
    case novel = "Novel"
    case original = "Original"
    case other = "Other"
    case pictureBook = "Picture book"
    case the4KomaManga = "4-koma manga"
    case visualNovel = "Visual novel"
    case webManga = "Web manga"
    case music = "Music"
}

enum AnimeType: String, Codable {
    case movie = "Movie"
    case ona = "ONA"
    case ova = "OVA"
    case special = "Special"
    case tv = "TV"
    case music = "Music"
    case null = "-"
}

