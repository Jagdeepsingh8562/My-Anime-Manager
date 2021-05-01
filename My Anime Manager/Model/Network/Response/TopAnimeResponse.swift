//
//  TopAnimeResponse.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation
// MARK: - TopAnimeResponse
struct TopAnimeResponse: Codable {
    let top: [SeasonAnime]

    enum CodingKeys: String, CodingKey {
        case top
    }
}
