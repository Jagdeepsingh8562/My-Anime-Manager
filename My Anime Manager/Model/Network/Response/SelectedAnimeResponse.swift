//
//  SelectedAnimeResponse.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation

struct SelectedAnimeResponse: Codable {
    let requestHash: String
    let requestCached: Bool
    let requestCacheExpiry, malID: Int
    let url: String
    let imageURL: String
    let trailerURL: String
    let title, titleEnglish, titleJapanese: String
    let titleSynonyms: [String]
    let type, source: String
    let episodes: Int
    let status: String
    let airing: Bool
    let aired: Aired
    let duration, rating: String
    let score: Double
    let scoredBy, rank, popularity, members: Int
    let favorites: Int
    let synopsis: String
    let background: JSONNull?
    let premiered, broadcast: String
    let related: Related
    let producers, licensors, studios, genres: [Genre]
    let openingThemes, endingThemes: [String]

    enum CodingKeys: String, CodingKey {
        case requestHash = "request_hash"
        case requestCached = "request_cached"
        case requestCacheExpiry = "request_cache_expiry"
        case malID = "mal_id"
        case url
        case imageURL = "image_url"
        case trailerURL = "trailer_url"
        case title
        case titleEnglish = "title_english"
        case titleJapanese = "title_japanese"
        case titleSynonyms = "title_synonyms"
        case type, source, episodes, status, airing, aired, duration, rating, score
        case scoredBy = "scored_by"
        case rank, popularity, members, favorites, synopsis, background, premiered, broadcast, related, producers, licensors, studios, genres
        case openingThemes = "opening_themes"
        case endingThemes = "ending_themes"
    }
}

// MARK: - Aired
struct Aired: Codable {
    let from, to: String?
    let prop: Prop
    let string: String
}

// MARK: - Prop
struct Prop: Codable {
    let from, to: From
}

// MARK: - From
struct From: Codable {
    let day, month, year: Int
}

// MARK: - Genre
struct Genre: Codable {
    let malID: Int
    let type: TypeEnumTwo
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type, name, url
    }
}

enum TypeEnumTwo: String, Codable {
    case anime = "anime"
    case manga = "manga"
}

// MARK: - Related
struct Related: Codable {
    let adaptation, sideStory, sequel: [Genre]

    enum CodingKeys: String, CodingKey {
        case adaptation = "Adaptation"
        case sideStory = "Side story"
        case sequel = "Sequel"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
