//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Carl Lee on 1/26/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif: NSObject, NSCoding {
    
    let url: URL
    let videoURL: URL
    var caption: String?
    let gifImage: UIImage
    var gifData: NSData?
    
    init(url: URL, videoURL: URL, caption: String?){
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = UIImage.gif(url: url.absoluteString) ?? UIImage()
        self.gifData = nil
    }

    required init?(coder aDecoder: NSCoder) {
        guard let url = aDecoder.decodeObject(forKey: "url") as? URL else {
            return nil
        }
        self.url = url

        guard let videoURL = aDecoder.decodeObject(forKey: "videoURL") as? URL else {
            return nil
        }
        self.videoURL = videoURL

        guard let caption = aDecoder.decodeObject(forKey: "caption") as? String else {
            return nil
        }
        self.caption = caption

        guard let gifImage = aDecoder.decodeObject(forKey: "gifimage") as? UIImage else {
            return nil
        }
        self.gifImage = gifImage

        guard let gifData = aDecoder.decodeObject(forKey: "gifdata") as? NSData else {
            return nil
        }
        self.gifData = gifData
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(videoURL, forKey: "videoURL")
        aCoder.encode(caption, forKey: "caption")
        aCoder.encode(gifImage, forKey: "gifimage")
        aCoder.encode(gifData, forKey: "gifdata")
    }


}
