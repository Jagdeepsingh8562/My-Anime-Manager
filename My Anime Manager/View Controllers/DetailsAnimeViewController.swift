//
//  DetailsAnimeViewController.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 01/05/21.
//

import Foundation
import UIKit

class DetailsAnimeViewController: UIViewController {
    
    var selectedAnime: SelectedAnimeResponse!
    var fav: Bool = false
    var dataController:DataController!
    let heartFill = UIImage(systemName: "heart.fill")
    let heart = UIImage(systemName: "heart")
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var otherNamesLabel: UILabel!
    @IBOutlet weak var episodesAndRatedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var synopsisTextView: UITextView!
    @IBOutlet weak var characterCollentionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var animeCharacters: [Character] = []
    
    override func viewDidLoad() {
        setupView()
        setupFavoriteIcon()
        characterCollentionView.delegate = self
        characterCollentionView.dataSource = self
        characterCalls()
        
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
        otherNamesLabel.text = selectedAnime.titleEnglish ?? ""
        episodesAndRatedLabel.text = "Ep:\(selectedAnime.episodes ?? 0) Ep/per:\(selectedAnime.duration )"
        synopsisTextView.text = selectedAnime.synopsis
        typeLabel.text = selectedAnime.type
        rankLabel.text = "Rank: \(selectedAnime.rank ?? 0)"
        setupFlowLayout() 
        guard let date = selectedAnime.aired?.string else {
            dateLabel.text = ""
            return
        }
        dateLabel.text = "Date:"+date
        
    }
    func setupFlowLayout() {
            let space:CGFloat = 6.0
            let dimension = (view.frame.size.width - (2 * space)) / 3.0
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
            flowLayout.scrollDirection = .horizontal
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
        let favEntity = FavoritesEntity(context: dataController.viewContext)
        favEntity.image = imageView.image?.pngData()
        favEntity.name = selectedAnime.title
        favEntity.score = selectedAnime.score ?? 0
        favEntity.animeId = Int32(selectedAnime.malID)
        //fav
        if favButton.image(for: .normal) == heart {
        favButton.setImage(heartFill, for: .normal)
            favEntity.favorite = true
            try? dataController.viewContext.save()
        }
        //not fav
        else {
            favButton.setImage(heart, for: .normal)
            favEntity.favorite = false
            //favoritesToDelete = favEntity
            //dataController.viewContext.delete()
            try? dataController.viewContext.save()
        }
    }
    
}
extension DetailsAnimeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/3.8, height: view.frame.height/5.5)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animeCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "charecterCell", for: indexPath) as! CustomCell
        cell.label.text = animeCharacters[indexPath.row].name
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.image = UIImage(named: "imagePlaceholder")
        JikanClient.getAnimeImage(urlString: animeCharacters[indexPath.item].imageURL) { (image) in
        cell.imageView.image = image
           
    }
        return cell
    }
    
    
}
