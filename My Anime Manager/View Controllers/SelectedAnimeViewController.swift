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
    @IBOutlet weak var bgDarkenView: UIView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var selectedAnime: SelectedAnimeResponse!
    var animeId: Int = 20
    var score:Double = 0
    var genres: [String] = []
    //
    var animeImage: UIImage!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var dataController:DataController!
    var fav: Bool = false
   // 
    let heartFill = UIImage(systemName: "heart.fill")
    let heart = UIImage(systemName: "heart")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgDarkenView.backgroundColor = .darkGray
        bgDarkenView.alpha = 0.35
        dataController = appDelegate.dataController
        
       
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
                if favor.name == selectedAnime.title {
                    fav = favor.favorite
                }
            }
            }
        }
    func viewUpdate() {
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
            //
            self.animeImage = image
        }
        
        progessview.lineColor = .systemRed
        progessview.lineWidth = 6
        progessview.labelSize = 0
        progessview.safePercent = 100
        progessview.setProgress(to:  score, withAnimation: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JikanClient.getSelectedAnime(animeId: animeId) { (success, error) in
            if success {
                self.selectedAnime = JikanClient.Const.selectedAnime
                print("dataa")
                
                // score 
                guard let score = self.selectedAnime.score else {
                    return
                }
                self.score = score/10
                //genre
                for genre in self.selectedAnime.genres {
                    self.genres.append(genre.name)
                }
                self.viewUpdate()
                self.setupFetchedRequest()
                self.setupFavoriteImage()
            }
            else {
                print(error!)
                }
            }
        
        
        
        }
    @IBAction func setFavorite(_ sender: Any) {
        let favEntity = FavoritesEntity(context: dataController.viewContext)
        favEntity.image = bgImageView.image?.pngData()
        favEntity.name = selectedAnime.title
        favEntity.score = selectedAnime.score ?? 0
        //fav
        if favButton.image(for: .normal) == heart {
        favButton.setImage(heartFill, for: .normal)
            favEntity.favorite = true
        }
        //not fav
        else {
            favButton.setImage(heart, for: .normal)
            favEntity.favorite = false
        }
        try? dataController.viewContext.save()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
