//
//  SelectedAnimeCharactersResponse.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation

// MARK: - SelectedAnimeCharactersResponse
struct SelectedAnimeCharactersResponse: Codable {
    let characters: [Character]
    let staff: [Staff]

    enum CodingKeys: String, CodingKey {
        case characters, staff
    }
}

// MARK: - Character
struct Character: Codable {
    let malID: Int
    let url: String
    let imageURL: String
    let name: String
    let role: Role
    //let voiceActors: [Staff]?

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url
        case imageURL = "image_url"
        case name, role
       // case voiceActors = "voice_actors"
    }
}

enum Role: String, Codable {
    case main = "Main"
    case supporting = "Supporting"
}

// MARK: - Staff
struct Staff: Codable {
    let malID: Int
    let name: String
    let url: String
    let imageURL: String
    let language: Language?
    let positions: [String]?

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case name, url
        case imageURL = "image_url"
        case language, positions
    }
}

enum Language: String, Codable {
    case brazilian = "Brazilian"
    case english = "English"
    case french = "French"
    case german = "German"
    case hebrew = "Hebrew"
    case hungarian = "Hungarian"
    case italian = "Italian"
    case japanese = "Japanese"
    case korean = "Korean"
    case spanish = "Spanish"
}
