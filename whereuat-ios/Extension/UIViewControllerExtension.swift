//
//  UIViewControllerExtension.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/11/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import UIKit

/*
 * This extension extends a view controller to let it update its own navigation bar.
 * Despite being not the greatest implementation of this functionality, it is the
 * canonical 'Swift' way to do things and adheres to the SlideMenuControllerSwift library
 * we are using for this application
 */
extension UIViewController {
    
    /*
     * setNavigationBarItems sets the icons in the navigation bar
     */
    func setNavigationBarItems(pageTitle: String = "whereu@") {
        // Set the color of the bar
        self.navigationController?.navigationBar.backgroundColor = ColorWheel.offWhite
        self.navigationController?.navigationBar.tintColor = ColorWheel.darkGray
        
        // Define left hand buttons
        let drawerButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu")!, style:UIBarButtonItemStyle.Plain, target: self, action: #selector(self.toggleLeft))
        let pageDescription: UIBarButtonItem = UIBarButtonItem(title: pageTitle, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        if let font = FontStyle.h4 {
            pageDescription.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:ColorWheel.darkGray], forState: UIControlState.Normal)
            pageDescription.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:ColorWheel.darkGray], forState: UIControlState.Disabled)
        }
        // Disable the page description so it is not a button
        pageDescription.enabled = false
        
        self.navigationItem.leftBarButtonItems = [drawerButton, pageDescription]

        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
}
