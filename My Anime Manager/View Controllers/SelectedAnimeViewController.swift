//
//  SelectedAnimeViewController.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 27/04/21.
//

import Foundation
import UIKit
import CoreData
class SelectedAnimeViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var ratinglabel: UILabel!
    @IBOutlet weak var moreInfo: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var selectedAnime: SelectedAnimeResponse!
    var animeId: Int = 20
    var score:Double = 0
    var genres: [String] = []
    var animeImage: UIImage!
    var result = [FavoritesEntity]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dataController:DataController!
    var fav: Bool = false
    let heartFill = UIImage(systemName: "heart.fill")
    let heart = UIImage(systemName: "heart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        bgImageView.alpha = 0.7
        moreInfo.layer.cornerRadius = 14
        isLoading(true)
        internetChecker { (success) in
            if success == false {
                self.showAlert(message: "Internet connection is not avilable", title: "Error")
            }
        }
        dataController = appDelegate.dataController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        bgImageView.image = UIImage(named: "imagePlaceholder")
        JikanClient.getSelectedAnime(animeId: animeId) { (success, error) in
            if success {
                guard let anime = JikanClient.Const.selectedAnime else {
                    return
                }
                self.selectedAnime = anime
                // score 
                if let score = self.selectedAnime.score {
                    self.score = score/10
                }
                self.genres.removeAll() 
                //genre
                for genre in self.selectedAnime.genres {
                    self.genres.append(genre.name)
                }
                self.setupView()
                self.setupFetchedRequest()
                self.setupFavoriteIcon()
            }
            else {
                self.showAlert(message: "\(error!.localizedDescription)", title: "Something is Wrong")
            }
        }
        
    }
    func isLoading(_ loading: Bool) {
        if loading {
            activityView.startAnimating()
            favButton.isEnabled = false
            moreInfo.isEnabled = false
        }
        else {
            activityView.stopAnimating()
            favButton.isEnabled = true
            moreInfo.isEnabled = true
        }
    }
    
    private func setupFavoriteIcon(){
        if fav {
            favButton.setImage(heartFill, for: .normal)
        }
        else {
            favButton.setImage(heart, for: .normal)
        }
        
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
    
    
    fileprivate func setupImage() {
        
        JikanClient.getPictures(animeId: selectedAnime.malID) { (success, error) in
            if success {
                let pictures = JikanClient.Const.pictures
                let random = Int.random(in: 0..<pictures.count)
                JikanClient.getAnimeImage(urlString: pictures[random].large) { (image) in
                    if let image = image  {
                        self.bgImageView.image = image
                    }
                }
                self.isLoading(false)
            }
            else{
               print(error!)
            }
        }
        //Image to Store in CoreData
        JikanClient.getAnimeImage(urlString: selectedAnime.imageURL) { (image) in
            if let image = image  {
                self.animeImage = image
            }
            
        }
        
    }
    
    private func setupView() {
        titleLabel.text = selectedAnime.title
        genreLabel.text = "\(genres.joined(separator: ","))"
        episodesLabel.text = "Episodes:\(selectedAnime.episodes ?? 0) Type: \(selectedAnime.type)"
        ratinglabel.text = "⭐️\(selectedAnime.score ?? 0.0)"
        setupImage()
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        
        //fav
        if favButton.image(for: .normal) == heart {
            favButton.setImage(heartFill, for: .normal)
            let favEntity = FavoritesEntity(context: dataController.viewContext)
            favEntity.image = animeImage.pngData()
            favEntity.name = selectedAnime.title
            favEntity.score = selectedAnime.score ?? 0
            favEntity.animeId = Int32(selectedAnime.malID)
            favEntity.favorite = true
            try? dataController.viewContext.save()
        }
        //not fav
        else {
            setupFetchedRequest()
            favButton.setImage(heart, for: .normal)
            var animeToDelete: FavoritesEntity?
            for f in result {
                if (f.animeId == selectedAnime.malID) {
                    animeToDelete = f
                }
            }
            dataController.viewContext.delete(animeToDelete!)
            try? dataController.viewContext.save()
            
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func moreInfoAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailsAnimeViewController") as! DetailsAnimeViewController
        vc.selectedAnime = selectedAnime
        vc.dataController = dataController
        vc.fav = fav
        vc.result = result
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SelectedAnimeViewController: DetailsAnimeViewDelegate {
    func sendAnimeId(malId: Int) {
        animeId = malId
    }
    
    func sendFavStatus(favStatus: Bool) {
        fav = favStatus
    }
}
