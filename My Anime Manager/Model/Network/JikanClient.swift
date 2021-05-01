//
//  jikanAPIClient.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation
import UIKit

class JikanClient {
    
    struct Const {
        //static var malId: Int = 0
        static var searchedAnime:[SearchAnime] = []
        static var topAnime: [SeasonAnime] = []
        static var selectedAnimeCharacters: [Character] = []
        static var selectedAnime: SelectedAnimeResponse!
        static var baseUrl:String = "https://api.jikan.moe/v3/"
        static var recommendationsAnime: [Recommendation] = []
        static var currentSeasonAnime: [SeasonAnime] = []
        static var upcommingSeasonAnime: [SeasonAnime] = []
        static var pictures: [Picture] = []
        
    }
    enum Endpoints {
        case searchAnime(String)
        case selectedAnime(Int)
        case recommendAnime(Int)
        case characters(Int)
        case topAnime
        case currentSeason
        case upcommingSeason
        case pictures(Int)
        
        var stringUrl: String {
            switch self {
            case .searchAnime(let query): return
                Const.baseUrl + "search/anime?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&page=1&type=anime&limit=15"
            case .selectedAnime(let animeId): return
                Const.baseUrl + "anime/\(animeId)"
            case .characters(let animeId): return Const.baseUrl + "anime/\(animeId)/characters_staff"
            case .recommendAnime(let animeId): return
                Const.baseUrl + "anime/\(animeId)/recommendations"
            case .topAnime: return Const.baseUrl + "top/anime/1/bypopularity"
            case .currentSeason: return Const.baseUrl + "season/\(SeasonHelper.currentYear())/\(SeasonHelper.currentSeason())"
            case .upcommingSeason: return Const.baseUrl + "season/later"
            case .pictures(let animeId): return Const.baseUrl + "anime/\(animeId)/pictures"
            }
        }
        var url: URL {
            return URL(string: stringUrl)! }
    }
    
    class func getSearchAnime(query: String, completion: @escaping (Bool, Error?) -> Void) -> URLSessionDataTask {
       let task = taskForGETRequest(url: Endpoints.searchAnime(query).url, responseType: SearchAnimeResponse.self) { (response, error) in
            if let response = response {
                Const.searchedAnime = response.results
                completion(true, nil)
            }
            else {
                completion(false, error)
            }
        }
        return task
    }
    
    class func getSelectedAnime(animeId: Int,completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.selectedAnime(animeId).url, responseType: SelectedAnimeResponse.self) { (response, error) in
            if let response = response {
                Const.selectedAnime = response
                completion(true, nil)
            }
            else {
                completion(false, error)
            }
        }
    }
    class func getRecommendAnime(animeId : Int,completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.recommendAnime(animeId).url, responseType: RecommendationsAnimeResponse.self) { (response, error) in
            if let response = response {
                Const.recommendationsAnime = response.recommendations
                completion(true, nil)
            }
            else {
                completion(false, error)
            }
        }
    }
    class func getCharacters(animeId : Int,completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.characters(animeId).url, responseType: SelectedAnimeCharactersResponse.self) { (response, error) in
            if let response = response {
                Const.selectedAnimeCharacters = response.characters
                completion(true,nil)
            } else {
                completion(false,error)
            }
        }
    }
    class func getCurrentSeasonAnime(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.currentSeason.url, responseType: SeasonResponse.self) { (response, error) in
            if let response = response {
                Const.currentSeasonAnime = response.anime
                completion(true,nil)
            }
            else {
                completion(false,error)
            }
        }
    }
    class func getUpcommingSeasonAnime(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.upcommingSeason.url, responseType: SeasonResponse.self) { (response, error) in
            if let response = response {
                Const.upcommingSeasonAnime = response.anime
                
                completion(true,nil)
            }
            else {
                completion(false,error)
            }
        }
    }
    class func getTopAnime(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.topAnime.url, responseType: TopAnimeResponse.self) { (response, error) in
            if let response = response {
                Const.topAnime = response.top
                completion(true, nil)
            }
            else {
                completion(false, error)
            }
        }
    }
    class func getPictures(animeId: Int,completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.pictures(animeId).url, responseType: ImageResponse.self) { (response, error) in
            if let response = response {
                Const.pictures = response.pictures
                completion(true, nil)
            }
            else {
                completion(false, error)
            }
        }
    }
    class func getAnimeImage(urlString:String ,completion: @escaping (_ image: UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                completion(imageFromCache) }
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let imgData = try Data(contentsOf: url)
                    guard let image = UIImage(data: imgData) else {
                        completion(nil)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let imageToCahce = image
                        imageCache.setObject(imageToCahce, forKey: urlString as AnyObject)
                        completion(imageToCahce)
                    }
                } catch {
                    print(error)
                }
            }
            
        }
    }
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
//                do {
//                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data) as! Error
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
                completion(nil,error)
            }
        }
        task.resume()
        
        return task
    }
    
}
