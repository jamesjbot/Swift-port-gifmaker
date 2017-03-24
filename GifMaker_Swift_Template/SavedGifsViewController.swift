//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by James Jongsurasithiwat on 3/17/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class SavedGifsViewController: UIViewController, UIGestureRecognizerDelegate {
    // MARK: - IBOutlet

    @IBOutlet weak var longPressGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func longpressHandle(_ sender: UILongPressGestureRecognizer) {
        func deleteGif (atItemPosition: IndexPath) {
            savedGifs.remove(at: atItemPosition.item)
            collectionView.reloadData()
            save(theseGifsToDisk: savedGifs)
        }

        switch sender.state {
        case UIGestureRecognizerState.began:
            let point = sender.location(in: collectionView)
            let indexpath = collectionView.indexPathForItem(at: point)
            // Do not delete if there is no UICollectionViewCell there.
            guard indexpath != nil else {
                return
            }
            let action = UIAlertAction(title: "Delete Gif",
                                       style: .destructive,
                                       handler:  { (alert: UIAlertAction!) in
                                        deleteGif(atItemPosition: indexpath!) })
            displayAlertWindow(title: "Delete Gif?", msg: "Delete this Gif?", actions: [action])
        case UIGestureRecognizerState.changed: break
            // Move floating annotation
//            mapView.removeAnnotation(floatingAnnotation)
//            let coordinateOnMap = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinateOnMap
//            mapView.addAnnotation(annotation)
//            floatingAnnotation = annotation

        case UIGestureRecognizerState.ended:
            print("UIGestureRecognizerEnded")
            break
//            insertPinIntoCoreData()
//            // Clear out floating annotation
//            floatingAnnotation = nil

        case UIGestureRecognizerState.cancelled:
            break

        case UIGestureRecognizerState.failed:
            break

        case UIGestureRecognizerState.possible:
            print("UIGestureRecognizer Possible")
            break

        default:
            break
        }
    }

    // MARK: - Constants
    let cellMargin: CGFloat = 12.0
    let SaveFileName: String = "SAVEDGIFS"

    // MARK: - Variables
    var saveFileURL: String {
        // Get the documents directory
        let directories: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = directories[0]
        let gifsPath = documentDirectoryPath.appending("/\(SaveFileName)")
        return gifsPath
    }

    var savedGifs: [Gif] = []


    // MARK: - Functions

    func showWelcome() {
        //if !UserDefaults.standard.bool(forKey: "WelcomeViewSeen") {
        guard UserDefaults.standard.bool(forKey: "WelcomeViewSeen") == false
            else {
                return
            }
        let welcomeView = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController")
        navigationController?.pushViewController(welcomeView!, animated: true)
    }

    // MARK: - View Life Cycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        longPressGestureRecognizer.minimumPressDuration = 0.25
        collectionView.addGestureRecognizer(longPressGestureRecognizer)

        showWelcome()

        // Blur the bottom
        let bottomBlur: CAGradientLayer = CAGradientLayer()
        bottomBlur.frame = CGRect(x: 0.0, y: view.frame.size.height - 100.0, width: view.frame.size.width, height: 100.0)
        bottomBlur.colors = [UIColor(white: 1.0, alpha: 0.0), UIColor.green]

        view.layer.insertSublayer(bottomBlur, above: collectionView.layer)

        // Retrieve gifs saved from last run
        if let gifs = NSKeyedUnarchiver.unarchiveObject(withFile: saveFileURL) {
            savedGifs = gifs as! [Gif]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the Image if there are gifs availabe for display

        emptyView.isHidden = (savedGifs.count != 0)

        collectionView.reloadData()

        // Hide navigation bar when there are no gifs

        navigationController?.navigationBar.isHidden = savedGifs.count == 0
        
    }
}


// MARK: -

extension SavedGifsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDataSource methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        let gif = savedGifs[indexPath.item]
        cell.configureForGif(gif: gif)
        return cell
    }


    // MARK: - UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // Send gif to detail view controller
        let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailView.localGif = savedGifs[indexPath.item]

        // We want modal style presentation
        detailView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext

        navigationController?.pushViewController(detailView, animated: true)

    }


    // MARK: - UICollectionViewFlowLayoutDelegate methods

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - (cellMargin * 2.0))/2.0
        return CGSize(width: width, height: width)
    }

}

// MARK: -

extension SavedGifsViewController: PreviewViewControllerDelegate {

    // MARK: - PreviewViewControllerDelegate

    func previewVC(preview: UIImage, didSaveGif gif: Gif) {
        var newGif = Gif(url: gif.url, videoURL: gif.videoURL, caption: gif.caption)
        newGif.gifData = NSData(contentsOf: newGif.url)
        savedGifs.append(newGif)

        // Save every new gif to document directory
        save(theseGifsToDisk: savedGifs)
        activityIndicator.stopAnimating()
    }

    func save(theseGifsToDisk gifs: [Gif]) {
        NSKeyedArchiver.archiveRootObject(gifs, toFile: saveFileURL)
    }
}

// MARK: -






