//
//  HelperExtentation.swift
//  My Anime Manager
//
//  Created by Jagdeep Singh on 04/05/21.
//

import Foundation
import UIKit
import Network

extension UIViewController {
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
    
    
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Cannot open link.", title: "Invalid Link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    func setupFlowLayout(flowLayout: UICollectionViewFlowLayout) {
        let space:CGFloat = 2.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        flowLayout.scrollDirection = .horizontal
    }

    func internetChecker()-> Bool{
        let monitor = NWPathMonitor()
        let netqueue = DispatchQueue(label: "InternetConnectionMonitor")
        var net:Bool = false
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                print("Internet connection is on.")
                net = true
            } else {
                print("There's no internet connection.")
                net = false
            }
        }
        
        monitor.start(queue: netqueue)
        return net
    }

}

