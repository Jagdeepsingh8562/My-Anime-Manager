//
//  SearchViewController.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 24/04/21.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var searchedAnimeString: [SearchAnime] = []
    var malId: Int = 0
    var currentSearchTask: URLSessionDataTask?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearchTask?.cancel()
        if searchText.count >= 3 {
            JikanClient.getSearchAnime(query: searchText) { (success, error) in
                if success {
                    
                    
                    self.searchedAnimeString = JikanClient.Const.searchedAnime
                    print(self.searchedAnimeString[0].title,self.searchedAnimeString.count)
                    self.tableView.reloadData()
                } else {
                    print(error!)
                }
                
            }
            self.tableView.reloadData()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedAnimeString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        let anime = searchedAnimeString[indexPath.row]
        cell.textLabel?.text = "\(anime.title)"
        cell.detailTextLabel?.text = "⭐️\(anime.score)"
        return cell
    }
    
    
}
