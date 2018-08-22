//
//  IntentViewController.swift
//  SpacePhotoIntentUI
//
//  Created by James Rochabrun on 8/21/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

@available(iOS 12.0, watchOS 5.0, *)
class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var spaceImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        
        guard interaction.intent is PhotoOfTheDayIntent else {
            completion(false, Set(), .zero)
            return
        }
        
        let width = self.extensionContext?.hostedViewMaximumAllowedSize.width ?? 320
        let desiredSize = CGSize(width: width, height: 700)
        
        // The intentHandlingStatus never changed to .ready for me. It did sometimes change to .success.
        // Maybe this is buggy or maybe I don't understand how this should work
        //
        // if interaction.intentHandlingStatus == .ready {
        //     // A view for the .ready state
        // } else if interaction.intentHandlingStatus == .success {
        //     // A view for the .success state
        // }
        
        activityIndicator.startAnimating()
        
        let photoInfoController = PhotoInfoManager()
        photoInfoController.fetchPhotoOfTheDay { (photoInfo) in
            if let photoInfo = photoInfo {
                photoInfoController.fetchUrlData(with: photoInfo.url) { [weak self] (data) in
                    if let data = data {
                        let image = UIImage(data: data)!
                        
                        DispatchQueue.main.async {
                            self?.spaceImageView.image = image
                            self?.activityIndicator.stopAnimating()
                            self?.activityIndicator.isHidden = true
                        }
                    }
                }
            }
        }
        completion(true, parameters, desiredSize)
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
}
