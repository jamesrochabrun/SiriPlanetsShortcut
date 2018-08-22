//
//  ViewController.swift
//  SiriPlanetsShortcut
//
//  Created by James Rochabrun on 8/21/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var planetView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let photoInfoController = PhotoInfoManager()
        photoInfoController.fetchPhotoOfTheDay { (photoInfo) in
            if let photoInfo = photoInfo {
                self.updateUI(with: photoInfo)
            }
        }
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
                
                self.title = photoInfo.title
                self.planetView.image = image
            }
        }
    }
}

