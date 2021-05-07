//
//  DetailsAnimeViewController.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 01/05/21.
//

import Foundation
import UIKit
import CoreData

protocol DetailsAnimeViewDelegate {
    func sendFavStatus(favStatus: Bool)
    func sendAnimeId(malId: Int)
}

class DetailsAnimeViewController: UIViewController {
    var selectedAnime: SelectedAnimeResponse!
    var fav: Bool = false
    var result = [FavoritesEntity]()
    var dataController:DataController!
    let heartFill = UIImage(systemName: "heart.fill")
    let heart = UIImage(systemName: "heart")
    var delegate: DetailsAnimeViewDelegate!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var otherNamesLabel: UILabel!
    @IBOutlet weak var episodesAndRatedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var characterCollentionView: CharectersCollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var recommedFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var recommendationCollentionView: RecommendationsAnimeCollectionView!
    var animeCharacters: [Character] = []
    var recommendations: [Recommendation] = []
    
    override func viewDidLoad() {
        setupView()
        characterCalls()
        getRecommentions()
        characterCollentionView.delegate = self
        characterCollentionView.dataSource = self
        recommendationCollentionView.delegate = self
        recommendationCollentionView.dataSource = self
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFetchedRequest()
        setupFavoriteIcon()
    }
    fileprivate func setupFetchedRequest() {
        let fetchRequest:NSFetchRequest<FavoritesEntity> = FavoritesEntity.fetchRequest()
        fetchRequest.sortDescriptors = []
        if let  result = try? dataController.viewContext.fetch(fetchRequest){
            for favor in result {
                if favor.animeId == selectedAnime.malID {
                    fav = favor.favorite
                }
            }
            self.result = result
        }
        
    }
    func getRecommentions() {
        JikanClient.getRecommendAnime(animeId: selectedAnime.malID) { (success, error) in
            if success {
                self.recommendations = JikanClient.Const.recommendationsAnime
                self.recommendationCollentionView.reloadData()
            }
            else {
                print(error!)
            }
        }
    }
    func characterCalls(){
        JikanClient.getCharacters(animeId: selectedAnime.malID) { (success, error) in
            if success {
                self.animeCharacters = JikanClient.Const.selectedAnimeCharacters
                self.characterCollentionView.reloadData()
            }
            else {
                print(error!)
            }
        }
    }
    func setupView(){
        imageView.image = UIImage(named: "imagePlaceholder")
        JikanClient.getAnimeImage(urlString: selectedAnime.imageURL, completion: { (image) in
            if let image = image {
                self.imageView.image = image }
        })
        nameLabel.text = selectedAnime.title
        otherNamesLabel.text = ""
        if let english = selectedAnime.titleEnglish {
            otherNamesLabel.text = "English:\(english)"
        }
        
        if selectedAnime.title == selectedAnime.titleEnglish {
            otherNamesLabel.text = ""
        }
        episodesAndRatedLabel.text = "Ep:\(selectedAnime.episodes ?? 0)(\(selectedAnime.duration))"
        synopsisTextView.text = selectedAnime.synopsis
        typeLabel.text = selectedAnime.type
        rankLabel.text = "Rank:#\(selectedAnime.rank ?? 0)"
        setupFlowLayout(flowLayout: flowLayout)
        setupFlowLayout(flowLayout: recommedFlowLayout)
        guard let date = selectedAnime.aired?.string else {
            dateLabel.text = ""
            return
        }
        dateLabel.text = "Date:"+date
        
    }
    private func setupFavoriteIcon(){
        if fav {
            favButton.setImage(heartFill, for: .normal)
        }
        else {
            favButton.setImage(heart, for: .normal)
        }
    }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setFavoriteAction(_ sender: Any) {
        
        //fav
        if favButton.image(for: .normal) == heart {
            favButton.setImage(heartFill, for: .normal)
            let favEntity = FavoritesEntity(context: dataController.viewContext)
            favEntity.image = imageView.image!.pngData()
            favEntity.name = selectedAnime.title
            favEntity.score = selectedAnime.score ?? 0
            favEntity.animeId = Int32(selectedAnime.malID)
            favEntity.favorite = true
            try? dataController.viewContext.save()
            
            delegate.sendFavStatus(favStatus: true)
        }
        //not fav
        else {
            favButton.setImage(heart, for: .normal)
            var animeToDelete: FavoritesEntity!
            for f in result {
                if (f.animeId == selectedAnime.malID) {
                    animeToDelete = f
                }
            }
            dataController.viewContext.delete(animeToDelete!)
            try? dataController.viewContext.save()
            delegate.sendFavStatus(favStatus: false)
        }
    }
    @IBAction func openSelectedAnimeUrl(_ sender: Any) {
        openLink(selectedAnime.url)
    }
}
extension DetailsAnimeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == characterCollentionView {
                return CGSize(width: view.frame.width/6, height: view.frame.height/5)
        }
        else {
                return CGSize(width: view.frame.width/6, height: view.frame.height/6)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == characterCollentionView {
            return animeCharacters.count }
        else {
            return recommendations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == characterCollentionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "charecterCell", for: indexPath) as! CustomCell
            cell.activityView.startAnimating()
            cell.label.text = animeCharacters[indexPath.row].name
            cell.imageView.image = UIImage(named: "imagePlaceholder")
            JikanClient.getAnimeImage(urlString: animeCharacters[indexPath.item].imageURL) { (image) in
                cell.imageView.image = image
                cell.activityView.stopAnimating()
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as! CustomCell
            cell.activityView.startAnimating()
            cell.label.text = recommendations[indexPath.row].title
            cell.imageView.image = UIImage(named: "imagePlaceholder")
            JikanClient.getAnimeImage(urlString: recommendations[indexPath.item].imageURL) { (image) in
                cell.imageView.image = image
                cell.activityView.stopAnimating()
            }
        
            return cell
        }
        
        }
    //recommendations
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recommendationCollentionView {
            delegate.sendAnimeId(malId: recommendations[indexPath.row].malID)
            delegate.sendFavStatus(favStatus: false)
            navigationController?.popViewController(animated: true)
        }
    }
    
    
}
