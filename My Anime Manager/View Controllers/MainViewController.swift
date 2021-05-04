//
//  MainViewController.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 17/04/21.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var topFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var currentFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var upcommingFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var topAnimeCollection: TopAnimeCollectionView!
    @IBOutlet weak var currentSeasonAnimeCollection: CurrentAnimeCollectionView!
    @IBOutlet weak var upcommingAnimeCollection: UpcommingAnimeCollectionView!
    @IBOutlet weak var seasonLabel: UILabel!
    
    var topAnimes: [SeasonAnime] = []
    var upcommingAnimes: [SeasonAnime] = []
    var currentAnimes: [SeasonAnime] = []
    var animeId:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seasonLabel.text = SeasonHelper.currentSeason()
        setupFlowLayout(flowLayout: topFlowLayout)
        setupFlowLayout(flowLayout: currentFlowLayout)
        setupFlowLayout(flowLayout: upcommingFlowLayout)
        apicalls()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func apicalls() {
        JikanClient.getCurrentSeasonAnime { (success, error) in
            if success {
                self.currentAnimes = Array(JikanClient.Const.currentSeasonAnime.prefix(50))
                self.currentSeasonAnimeCollection.reloadData()
                            }
            else {
                self.showAlert(message: "\(error!.localizedDescription)", title: "Something is Wrong")
            }
            
        }
        JikanClient.getTopAnime { (success, error) in
            if   success {  self.topAnimes = Array(JikanClient.Const.topAnime.prefix(50))
                self.topAnimeCollection.reloadData()

            } else { self.showAlert(message: "\(error!.localizedDescription)", title: "Something is Wrong") }
        }
        JikanClient.getUpcommingSeasonAnime { (success, error) in
            if success  {self.upcommingAnimes = Array(JikanClient.Const.upcommingSeasonAnime.prefix(50))
                self.upcommingAnimeCollection.reloadData()
            }
            else{
                self.showAlert(message: "\(error!.localizedDescription)", title: "Something is Wrong")
            }
        }
        
    }
}
let imageCache = NSCache<AnyObject, AnyObject>()


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topAnimeCollection {
            return CGSize(width: view.frame.width/4, height: view.frame.height/5)
        }
        else if collectionView == currentSeasonAnimeCollection{
            return CGSize(width: view.frame.width/4, height: view.frame.height/5)
        }
        else {
            return CGSize(width: view.frame.width/4, height: view.frame.height/5)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topAnimeCollection{
            return topAnimes.count
        }
        else if collectionView == currentSeasonAnimeCollection{
            return currentAnimes.count
        }
        else {
            return upcommingAnimes.count
            
        }
    }
    func customCollectionViewCell(_ collectionView: UICollectionView,indexPath: IndexPath,reuseIdentifier: String,animeArray: [SeasonAnime]) -> UICollectionViewCell{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCell
            cell.activityView.startAnimating()
            cell.label.text = animeArray[indexPath.row].title
            cell.imageView.image = UIImage(named: "imagePlaceholder")
            JikanClient.getAnimeImage(urlString: animeArray[indexPath.item].imageURL) { (image) in
            cell.imageView.image = image
            cell.activityView.stopAnimating()
        }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topAnimeCollection{
            let cell =  customCollectionViewCell(collectionView, indexPath: indexPath, reuseIdentifier: "cellA", animeArray: topAnimes)
            return cell
        }
        else if collectionView == currentSeasonAnimeCollection{
                let cell = customCollectionViewCell(collectionView, indexPath: indexPath, reuseIdentifier: "cellB", animeArray: currentAnimes)
                return cell
        }
            let cell = customCollectionViewCell(collectionView, indexPath: indexPath, reuseIdentifier: "cellC", animeArray: upcommingAnimes)
            return cell
        
    }
    //
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topAnimeCollection {
            animeId = topAnimes[indexPath.item].malID
        }
        else if collectionView == currentSeasonAnimeCollection {
            animeId = currentAnimes[indexPath.item].malID
        }
        else {
            animeId = upcommingAnimes[indexPath.item].malID
        }
        let vc = self.storyboard?.instantiateViewController(identifier: "SelectedAnimeViewController") as! SelectedAnimeViewController
        vc.animeId = animeId
        navigationController?.pushViewController(vc, animated: true)
        
    }
   
    
}


