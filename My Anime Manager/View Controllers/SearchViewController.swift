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
        JikanClient.getSearchAnime(query: searchText) { (success, error) in
            if success {
                self.searchedAnimeString = JikanClient.Const.searchedAnime
                
                self.tableView.reloadData()
            } else {
                print(error!)
            }
            
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SearchViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedAnimeString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        cell.textLabel?.text = searchedAnimeString[indexPath.row].title
        return cell
    }
    
    
}
