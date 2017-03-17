//
//  GifCell.swift
//  GifMaker_Swift_Template
//
//  Created by James Jongsurasithiwat on 3/17/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class GifCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var gifImageView: UIImageView!


    // MARK: - Functions
    func configureForGif(gif: Gif) {
        gifImageView.image = gif.gifImage
    }
}
