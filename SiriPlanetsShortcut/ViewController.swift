//
//  ViewController.swift
//  SiriPlanetsShortcut
//
//  Created by James Rochabrun on 8/21/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {
    
    @IBOutlet weak var planetView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let photoInfoController = PhotoInfoManager()
        photoInfoController.fetchPhotoOfTheDay { (photoInfo) in
            if let photoInfo = photoInfo {
                self.updateUI(with: photoInfo)
            }
        }
        /// Donate
        donateInteraction()
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        
        let photoInfoController = PhotoInfoManager()
        photoInfoController.fetchUrlData(with: photoInfo.url) { (data) in
            guard
                let data = data,
                let image = UIImage(data: data)
                else {
                    return
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.titleLabel.text = photoInfo.title
                self.planetView.image = image
            }
        }
    }
}

/// MARK:- Donation
extension ViewController {
    
    func donateInteraction() {
        
        let intent = PhotoOfTheDayIntent()
        
        intent.suggestedInvocationPhrase = "Energize"
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { error in
            
            guard let localError = error else { return }
            guard let err = localError as NSError? else {
                print("Successfully donated interaction")
                return
            }
            print("ERROR -> \(err)")
        }
    }
    
    
}
