//
//  CustomCell.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 21/04/21.
//

import Foundation
import UIKit
class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
       super.awakeFromNib()
       //custom logic goes here
    }
    init() {
        super.init(frame: .zero)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
}
