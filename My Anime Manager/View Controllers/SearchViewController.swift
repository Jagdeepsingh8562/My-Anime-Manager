//
//  SearchViewController.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 24/04/21.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var searchedAnime: [SearchAnime] = []
    var currentSearchTask: URLSessionDataTask?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearchTask?.cancel()
        if searchText.count >= 3 {
            currentSearchTask = JikanClient.getSearchAnime(query: searchText) { (success, error) in
                if success {
                    self.searchedAnime = JikanClient.Const.searchedAnime
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedAnime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        let anime = searchedAnime[indexPath.row]
        cell.textLabel?.text = "\(anime.title)"
        cell.detailTextLabel?.text = "⭐️\(anime.score)"
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("qwertyuio")
        let vc = self.storyboard?.instantiateViewController(identifier: "SelectedAnimeViewController") as! SelectedAnimeViewController
        vc.animeId = searchedAnime[indexPath.item].malID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}
