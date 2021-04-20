//
//  jikanAPIClient.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 20/04/21.
//

import Foundation

class JikanClient {
    struct Const {
        //static var malId: Int = 0
        static var anime:[Anime] = []
        static var selectedAnime: SelectedAnimeResponse!
        static var baseUrl:String = "https://api.jikan.moe/v3/"
    }
    enum Endpoints {
        case searchAnime(String)
        case selectedAnime(Int)
        
        var stringUrl: String {
            switch self {
            case .searchAnime(let query): return
                Const.baseUrl + "search/anime?q=\(query)&page=1&type=anime"
            case .selectedAnime(let animeId): return
                Const.baseUrl + "anime/\(animeId)"
           
            }
        }
        var url: URL {
            return URL(string: stringUrl)! }
    }
    
    class func getSearchAnime(query: String, completion: @escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.searchAnime(query).url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else{
                    DispatchQueue.main.async {
                    completion(false, error)
                    }
                    return
            }
                do {
                    let responseObject = try JSONDecoder().decode(SearchAnimeResponse.self, from: data)
                    print(type(of: responseObject))
                    Const.anime = responseObject.results
                    DispatchQueue.main.async {
                    completion(true, nil)
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                    completion(false, error)
                    }
                }
            }
            task.resume()
       }
    
    func selectedAnime(animeId: Int,completion: @escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.selectedAnime(animeId).url)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
        guard let data = data else {
            completion(false,error)
            return
        }
        do {
            let responseObject = try JSONDecoder().decode(SelectedAnimeResponse.self, from: data)
            Const.selectedAnime = responseObject
            
        DispatchQueue.main.async {
            print(responseObject.related.sequel[0].name)
            completion(true,nil)
        }
        } catch {
            print(error)
        }
        
        }
    task.resume()
    }
}
