//
//  SelectedNavController.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 29/04/21.
//

import Foundation
import UIKit
class SelectedNavController: UINavigationController {
    var animeId: Int = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let vc = SelectedAnimeViewController()
        vc.animeId = animeId
        navigationController?.pushViewController(SelectedAnimeViewController(), animated: true)
    }
}
