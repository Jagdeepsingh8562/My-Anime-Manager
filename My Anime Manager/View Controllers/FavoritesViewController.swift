//
//  FavoritesViewController.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 28/04/21.
//

import Foundation
import UIKit
import CoreData

class FavoritesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dataController:DataController!
    var favEntity = [FavoritesEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataController = appDelegate.dataController
        
    }
    fileprivate func setupFetchedRequest() {
        let fetchRequest:NSFetchRequest<FavoritesEntity> = FavoritesEntity.fetchRequest()
        fetchRequest.sortDescriptors = []
        if let  result = try? dataController.viewContext.fetch(fetchRequest){
            favEntity = result
           
            }
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedRequest()
        tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
        print(favEntity.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favEntity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fav = favEntity[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as! FavoritesCustomCell
        cell.favimageView.image = UIImage(data: fav.image!)
        cell.titleLabel.text = fav.name
        cell.subtitleLabel.text = "⭐️\(fav.score)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SelectedAnimeViewController") as! SelectedAnimeViewController
        vc.animeId = Int(favEntity[indexPath.row].animeId)
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete: dataController.viewContext.delete(favEntity[indexPath.row])
        try? dataController.viewContext.save()
        tableView.reloadData()
        default: () // Unsupported
        }
    }
    
}
