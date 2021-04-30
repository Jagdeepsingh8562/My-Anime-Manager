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
    @IBOutlet weak var Episodeslabel: UILabel!
    @IBOutlet weak var ratinglabel: UILabel!
    @IBOutlet weak var moreInfo: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var progessview: CircularProgressBar!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var selectedAnime: SelectedAnimeResponse!
    var animeId: Int = 20
    var score:Double = 0
    var genres: [String] = []

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dataController:DataController!
    var fav: Bool = false
    var favoritesToDelete: FavoritesEntity!
    let heartFill = UIImage(systemName: "heart.fill")
    let heart = UIImage(systemName: "heart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        bgImageView.alpha = 0.7
        dataController = appDelegate.dataController
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
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
                
                //genre
                for genre in self.selectedAnime.genres {
                    self.genres.append(genre.name)
                }
                self.setupView()
                self.setupFetchedRequest()
                self.setupFavoriteImage()
            }
            else {
                print(error!)
                }
            }
        }
    private func setupFavoriteImage(){
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
                    favoritesToDelete = favor
                }
            }
            }
        }
    fileprivate func setupProgressBar() {
        progessview.lineColor = .systemRed
        progessview.lineWidth = 6
        progessview.labelSize = 0
        progessview.safePercent = 100
        progessview.setProgress(to:  score, withAnimation: true)
    }
    
    func setupView() {
        titleLabel.text = selectedAnime.title
        genreLabel.text = "\(genres.joined(separator: ","))"
        Episodeslabel.text = "Episodes:\(selectedAnime.episodes ?? 0)"
        ratinglabel.text = "\(selectedAnime.score ?? 0.0)"
        bgImageView.image = UIImage(named: "imagePlaceholder")
        JikanClient.getAnimeImage(urlString: selectedAnime.imageURL) { (image) in
            guard let image = image else {
                return
            }
            self.bgImageView.image = image
            
        }
        
        setupProgressBar()
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        let favEntity = FavoritesEntity(context: dataController.viewContext)
        favEntity.image = bgImageView.image?.pngData()
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
            favoritesToDelete = favEntity
            dataController.viewContext.delete(favoritesToDelete)
            try? dataController.viewContext.save()
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
}
