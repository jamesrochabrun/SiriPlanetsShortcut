//
//  PhotoOfTheDayHandler.swift
//  SiriPlanetsShortcut
//
//  Created by James Rochabrun on 8/21/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

/// MARK:- This is wher we perfomr the main actions

@available(iOSApplicationExtension 12.0, *)
class PhotoOfTheDayHandler: NSObject, PhotoOfTheDayIntentHandling {
    
    
    func confirm(intent: PhotoOfTheDayIntent, completion: @escaping (PhotoOfTheDayIntentResponse) -> Void) {
        let photoInfoController = PhotoInfoManager()
        photoInfoController.fetchPhotoOfTheDay { (photoInfo) in
            if let photoInfo = photoInfo {
                if photoInfo.isImage {
                    completion(PhotoOfTheDayIntentResponse(code: .ready, userActivity: nil))
                } else {
                    completion(PhotoOfTheDayIntentResponse(code: .failureNoImage, userActivity: nil))
                }
            }
        }
    }
    
    func handle(intent: PhotoOfTheDayIntent, completion: @escaping (PhotoOfTheDayIntentResponse) -> Void) {
        let photoInfoController = PhotoInfoManager()
        photoInfoController.fetchPhotoOfTheDay { (photoInfo) in
            if let photoInfo = photoInfo {
                completion(PhotoOfTheDayIntentResponse.success(photoTitle: photoInfo.title))
            }
        }
    }
}
