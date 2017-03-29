//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Carl Lee on 1/26/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

internal protocol PreviewViewControllerDelegate {
    func previewVC(preview: UIImage, didSaveGif gif: Gif)
    func reloadCollection()
}

class PreviewViewController: UIViewController {

    // MARK: - Variables
    var delegate: PreviewViewControllerDelegate?
    var gif: Gif?

    // MARK: - IBOutlets

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var captionImageView: UIImageView!

    // MARK: - IBActions

    // Allows us
    @IBAction func createAndSave(_ sender: UIButton) {
        if let gifImage = gif?.gifImage {
            if let gif = self.gif {
                delegate?.previewVC(preview: gifImage, didSaveGif: gif)
            }
        }
        delegate?.reloadCollection()
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func shareGif(_ sender: Any) {
        if let gif = self.gif {
            share(thisGif: gif)
        }
    }

    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        captionImageView.image = gif?.gifImage
        let pink = UIColor(colorLiteralRed: 255.0/255.0,
                           green: 65.0/255.0,
                           blue: 112.0/255.0,
                           alpha: 1.0)
        shareButton.layer.borderWidth = 2.0
        shareButton.layer.borderColor = pink.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



