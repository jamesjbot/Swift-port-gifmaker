//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Carl Lee on 1/26/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.


import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

//Regift constants
let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBAction func presentVideoOptions(){

        // If the device has no camera just go to the library
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            launchPhotoLibrary()
        } else { // Allow the user to choose how they want to import a video.

            let newGifActionSheet = UIAlertController(title: "Create new GIF", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)

            let recordVideo = UIAlertAction(title: "Record a Video", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.launchVideoCamera()
            })
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.launchPhotoLibrary()
            })
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            newGifActionSheet.addAction(recordVideo)
            newGifActionSheet.addAction(chooseFromExisting)
            newGifActionSheet.addAction(cancel)
            
            present(newGifActionSheet, animated: true, completion: nil)
            let pinkColor = UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            newGifActionSheet.view.tintColor = pinkColor
        }
    }


    // Start activity indicator if view is SavedGifsView
    func launchActivityIndicator() {
        if self is SavedGifsViewController {
            (self as! SavedGifsViewController).activityIndicator.startAnimating()
        }
    }


    // Stop activity indicator if view is SavedGifsView
    func shutdownActivityIndicator() {
        if self is SavedGifsViewController {
            (self as! SavedGifsViewController).activityIndicator.stopAnimating()
        }
    }


    // Select the source as video camera
    func launchVideoCamera() {

        launchActivityIndicator()
        let recordVideoController = pickerControllerWithSource(source: UIImagePickerControllerSourceType.camera)
        // Allow start and end on the video picker
        recordVideoController.allowsEditing = true
        present(recordVideoController, animated: true, completion: nil)
        
    }


    // Select the source as video library
    func launchPhotoLibrary(){

        launchActivityIndicator()
        let recordVideoController = pickerControllerWithSource(source: .savedPhotosAlbum)
        // Since this version of Swift doesn't allow trimming information to be pased back
        recordVideoController.allowsEditing = false
        present(recordVideoController, animated: true, completion: nil)
        
    }


    // Returns a UIImagePickerController bound to a specific source
    func pickerControllerWithSource(source: UIImagePickerControllerSourceType) -> UIImagePickerController{
        
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        return picker
        
    }


    // MARK: - UIImagePickerControllerDelegate Methods

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("DidfinishPickingMediaWithInfo called")
        let mediaType = info[UIImagePickerControllerMediaType] as! String

        // Note as of Swift 3 trimming on photolibrary movies does not generate start and end information.

        if mediaType == kUTTypeMovie as String{
            let videoURL = info[UIImagePickerControllerMediaURL] as! URL
            let start: NSNumber? = info["_UIImagePickerControllerVideoEditingStart"]as! NSNumber?
            let end: NSNumber? = info["_UIImagePickerControllerVideoEditingEnd"] as! NSNumber?
            var duration: NSNumber?
            if let start = start {
                duration = NSNumber(value: (end!.floatValue) - (start.floatValue))
            } else{
                duration = nil
            }

            cropVideoToSquare(rawVideoURL: videoURL, start: start, duration: duration)
            // Dismiss the imagePicker
            print("exiting DidfinishpickingMediaWithInfo")
            dismiss(animated: true, completion: nil)
            print("After dismiss in didFinishPickingMdiaWithInfo")
        }
    }


    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        shutdownActivityIndicator()
        dismiss(animated: true, completion: nil)
    }


    // Convert to gif, asynchronously called after video is cropped to square.
    func convertVideoToGIF(videoURL: URL, start: NSNumber?, duration: NSNumber?){

        let regift: Regift
        if (start == nil){
            // Untrimmed video
            regift = Regift(sourceFileURL: videoURL as URL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        } else{
            // Trimmed video
            regift = Regift(sourceFileURL: videoURL as URL, destinationFileURL: nil, startTime: (start?.floatValue)!, duration: (duration?.floatValue)!, frameRate: frameCount, loopCount: loopCount)
        }

        let gifURL = regift.createGif()
        let gif = Gif(url: gifURL!, videoURL: videoURL as URL, caption: nil)
        print("convert squared video to gif calling displayGIF")
        displayGIF(gif: gif)
    }

    func cropVideoToSquare(rawVideoURL: URL, start: NSNumber?, duration: NSNumber?) {

        //Create the AVAsset and AVAssetTrack
        let videoAsset = AVAsset(url: rawVideoURL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]

        // Crop to square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
        print(videoComposition.renderSize)
        videoComposition.frameDuration = CMTimeMake(1, 30)

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTime(seconds: 60, preferredTimescale: 30))

        // rotate to portrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let firstTransform = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: -(videoTrack.naturalSize.width-videoTrack.naturalSize.height)/2.0)
        // Turn portrait into landscape videos
        let secondTransform = firstTransform.rotated(by: CGFloat(M_PI_2))

        let finalTransform = secondTransform
        transformer.setTransform(finalTransform, at: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]

        //export
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
        print(videoComposition.renderSize)
        exporter.videoComposition = videoComposition
        let path = createPath()
        exporter.outputURL = NSURL(fileURLWithPath: path) as URL
        exporter.outputFileType = AVFileTypeQuickTimeMovie

        // Launch Activity infidator
        if self is SavedGifsViewController {
            launchActivityIndicator()
        }

        exporter.exportAsynchronously(completionHandler: {
            let squareURL = exporter.outputURL!
            self.convertVideoToGIF(videoURL: squareURL, start: start, duration: duration)
        })
    }


    // Creates output path for video after it has been cropped to square
    func createPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        var outputURL = documentsDirectory.appending("/output/\(NSDate.timeIntervalSinceReferenceDate)")

        do{
            try FileManager.default.createDirectory(atPath: outputURL, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError{
            print(error.localizedDescription)
        }

        outputURL = outputURL.appending("squareoutput.mov")

        return outputURL
    }


    // Dependency inject gif into the GifEditorViewController
    func displayGIF(gif: Gif){
        print("displayGif called")
        let gifEditiorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditiorVC.gif = gif
        gifEditiorVC.savedGifsViewController = self as! PreviewViewControllerDelegate
        print("displayGif pushingGifEditor")
        navigationController?.pushViewController(gifEditiorVC, animated: true)
        print("displayGif exited")
    }


    // Presents action sheet to share gif
    func share(thisGif: Gif) {
        var animatedGif: NSData?
        if let gifData = thisGif.gifData {
            // When used a previously saved gif the NSData is stored and the 
            // url is now invalid
            animatedGif =  gifData
        } else {
            // When createing a new gif only the url is valid
            animatedGif =  NSData(contentsOf: thisGif.url)
        }
        let itemToShare = [animatedGif]
        let shareController = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
        shareController.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed){
                self.navigationController?.popToRootViewController(animated: true)
            }
        }

        navigationController?.present(shareController, animated: true, completion: nil)
    }


}
