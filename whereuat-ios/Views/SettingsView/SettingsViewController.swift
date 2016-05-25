//
//  SettingsViewController.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/11/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawVersionTextView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItems("Settings")
    }
    
    func drawVersionTextView() {
        let textBoxWidth = CGFloat(100)
        let versionTextView = UITextView(frame: CGRect(x: (self.view.frame.size.width/2 - textBoxWidth/2), y: 100, width: 100, height: 200))
        let versionNumber: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        versionTextView.text = "whereu@ Version " + String(versionNumber!)
        versionTextView.font = FontStyle.p
        versionTextView.textColor = ColorWheel.darkGray
        versionTextView.textAlignment = NSTextAlignment.Center
        self.view.addSubview(versionTextView)
    }
    
}