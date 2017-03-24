//
//  ExtensionUIViewController.swift
//  BreweryTour
//
//  Created by James Jongsurasithiwat on 11/1/16.
//  Copyright © 2016 James Jongs. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: - Function
    
    // Specialized alert displays for UIViewControllers
    // This create a generic display with a dismiss embedded.
    // It can be expanded by adding more UIAlertActions.
    //
    // How to use:
    // Set the function to the action button
    // let action = UIAlertAction(title: "Search Online",
    //                               style: .default,
    //                               handler: searchOnline)
    // displayAlertWindow(title: "Some title",
    //    msg: "Some message",
    //    actions: [action])
    //
    //
    // func searchOnline(_ action: UIAlertAction) {
    // }

    func displayAlertWindow(title: String, msg: String, actions: [UIAlertAction]? = nil){
        DispatchQueue.main.async {
            () -> Void in
            let alertWindow: UIAlertController = UIAlertController(title: title,
                                                                   message: msg,
                                                                   preferredStyle: UIAlertControllerStyle.alert)
            alertWindow.addAction(self.dismissAction())
            if let array = actions {
                for action in array {
                    alertWindow.addAction(action)
                }
            }
            self.present(alertWindow, animated: true, completion: nil)
        }
    }
    
    
    private func dismissAction()-> UIAlertAction {
        return UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
    }
    

}
