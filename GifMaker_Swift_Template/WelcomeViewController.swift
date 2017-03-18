//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Carl Lee on 1/26/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let proofOfConceptGif = UIImage.gif(name: "tinaFeyHiFive")
        gifImageView.image = proofOfConceptGif
        UserDefaults.standard.set(true, forKey: "WelcomeViewSeen")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
