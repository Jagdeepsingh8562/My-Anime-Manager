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
    
    var topAnimes: [TopAnime] = []
    var upcommingAnimes: [SeasonAnime] = []
    var currentAnimes: [SeasonAnime] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        seasonLabel.text = SeasonHelper.currentSeason()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setupFlowLayout(flowLayout: topFlowLayout)
        setupFlowLayout(flowLayout: currentFlowLayout)
        setupFlowLayout(flowLayout: upcommingFlowLayout)
        apicalls()
    }
    
    
    func setupFlowLayout(flowLayout: UICollectionViewFlowLayout) {
            let space:CGFloat = 6.0
            let dimension = (view.frame.size.width - (2 * space)) / 3.0
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
            flowLayout.scrollDirection = .horizontal
        }
    func apicalls() {
        JikanClient.getCurrentSeasonAnime { (success, error) in
            
            if success {
                self.currentAnimes = Array(JikanClient.Const.currentSeasonAnime.prefix(50))
                self.currentSeasonAnimeCollection.reloadData()
                            }
            else {
                print(error!)
                
            }
            
        }
        JikanClient.getTopAnime { (success, error) in
            if   success {  self.topAnimes = Array(JikanClient.Const.topAnime.prefix(50))
                self.topAnimeCollection.reloadData()

            } else { print(error!) }
        }
        JikanClient.getUpcommingSeasonAnime { (success, error) in
            if success  {self.upcommingAnimes = Array(JikanClient.Const.upcommingSeasonAnime.prefix(50))
                self.upcommingAnimeCollection.reloadData()
            }
            else{print(error!)}
        }
        
    }
}
let imageCache = NSCache<AnyObject, AnyObject>()


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topAnimeCollection {
            return CGSize(width: view.frame.width/4, height: view.frame.height/6)
        }
        else if collectionView == currentSeasonAnimeCollection{
            return CGSize(width: view.frame.width/4, height: view.frame.height/6)
        }
        else {
            return CGSize(width: view.frame.width/4, height: view.frame.height/6)        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topAnimeCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellA", for: indexPath) as! CustomCell
            cell.label.text = topAnimes[indexPath.row].title
            cell.imageView.image = UIImage(named: "imagePlaceholder")
            JikanClient.getAnimeImage(urlString: topAnimes[indexPath.item].imageURL) { (image) in
                cell.imageView.image = image
            }
            print("something \(indexPath.item)")
        return cell
        }
        else if collectionView == currentSeasonAnimeCollection{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellB", for: indexPath) as! CustomCell
            cell.label.text = currentAnimes[indexPath.row].title
            cell.imageView.image = UIImage(named: "imagePlaceholder")
            JikanClient.getAnimeImage(urlString: currentAnimes[indexPath.item].imageURL) { (image) in
                cell.imageView.image = image
            }
        return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellC", for: indexPath) as! CustomCell
        cell.label.text = upcommingAnimes[indexPath.row].title
        cell.imageView.image = UIImage(named: "imagePlaceholder")
        JikanClient.getAnimeImage(urlString: upcommingAnimes[indexPath.item].imageURL) { (image) in
            cell.imageView.image = image
        }
        return cell
        
    }
    
}


