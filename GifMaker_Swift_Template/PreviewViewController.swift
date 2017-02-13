//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Carl Lee on 1/26/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var gif: Gif?

    @IBOutlet weak var captionImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionImageView.image = gif?.gifImage

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
