//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Carl Lee on 1/26/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif{
    
    let url: URL
    let videoURL: URL
    var caption: String?
    let gifImage: UIImage?
    var gifData: NSData?
    
    init(url: URL, videoURL: URL, caption: String?){
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = UIImage.gif(url: url.absoluteString)
        self.gifData = nil
    }

}
