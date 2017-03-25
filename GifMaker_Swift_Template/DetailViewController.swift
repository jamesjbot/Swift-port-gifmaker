//
//  DetailViewController.swift
//  GifMaker_Swift_Template
//
//  Created by James Jongsurasithiwat on 3/17/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {

    // MARK: - Variables

    var localGif: Gif?

    // MARK: - IBActions

    @IBAction func shareGif(_ sender: UIButton) {
        share(thisGif: localGif!)
    }

    @IBAction func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - IBOutlets

    @IBOutlet weak var gifImageView: UIImageView!

    // MARK: - Functions


    // MARK: - View Life Cycle Functions

    override func viewDidLoad() {
        gifImageView.image = localGif?.gifImage
    }

}
