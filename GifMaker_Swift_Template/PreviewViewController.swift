//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Carl Lee on 1/26/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate {
    func previewVC(preview: UIImage, didSaveGif gif: Gif)
}

class PreviewViewController: UIViewController {

    // MARK: - Variables
    var delegate: PreviewViewControllerDelegate!
    var gif: Gif?

    // MARK: - IBOutlets


    @IBOutlet weak var captionImageView: UIImageView!

    // MARK: - IBActions

    // Allows us
    @IBAction func createAndSave(_ sender: UIButton) {
        if let gifImage = gif?.gifImage {
            if let gif = self.gif {
                delegate?.previewVC(preview: gifImage, didSaveGif: gif)
            }
        }

        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func shareGif(_ sender: Any) {
        
        let animatedGif =  NSData(contentsOf: (gif?.url)!)
        let itemToShare = [animatedGif]
        let shareController = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
        shareController.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed){
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        navigationController?.present(shareController, animated: true, completion: nil)
    }

    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        captionImageView.image = gif?.gifImage

        // Do any additional setup after loading the view.
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



