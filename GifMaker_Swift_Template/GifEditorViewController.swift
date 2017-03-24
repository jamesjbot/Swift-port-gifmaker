//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Carl Lee on 1/26/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var gifImageView: UIImageView!

    var gif:Gif?
    var savedGifsViewController: PreviewViewControllerDelegate!

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        subscribeToKeyboardNotifications()

    }


    override func viewDidLoad() {
        captionTextField.delegate = self
        gifImageView.image = gif?.gifImage
        let textAttributes: Dictionary = [
            NSStrokeColorAttributeName : UIColor.black,
            NSStrokeWidthAttributeName : -4.0,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
            ] as [String : Any]
        captionTextField.defaultTextAttributes = textAttributes
        captionTextField.textAlignment = .center
        captionTextField.placeholder = "Add Caption"
        
        // Always show the navigation bar on this screen
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: TEXT FIELD EDITING METHODS

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    // MARK: IBACTIONS

    @IBAction func presentPreview(_ sender: Any) {
        
        let previewVC = self.storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootView = appDelegate.window!.rootViewController
        previewVC.delegate = savedGifsViewController

        gif?.caption = captionTextField.text
        let regift = Regift(sourceFileURL: (gif?.videoURL)!, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        let gifURL = regift.createGif(caption: captionTextField.text, font: captionTextField.font)
        let newGif = Gif(url: gifURL!, videoURL: (gif?.videoURL)!, caption: captionTextField.text)
        previewVC.gif = newGif
        navigationController?.pushViewController(previewVC, animated: true)
    }
}


extension GifEditorViewController {
    // MARK: KEYBOARD ELEVEVATING METHODS
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(GifEditorViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GifEditorViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        if (self.view.frame.origin.y >= 0){
            var rect = self.view.frame
            rect.origin.y -= getKeyboardHeight(notification: notification)
            self.view.frame = rect
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if (self.view.frame.origin.y < 0){
            var rect = self.view.frame
            rect.origin.y += getKeyboardHeight(notification: notification)
            self.view.frame = rect
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}
