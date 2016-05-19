//
//  DrawerViewController.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/11/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum Menu: Int {
    case Home = 0
    case KeyLocations
    case PendingRequests
    case Settings
}

protocol DrawerProtocol {
    func changeViewController(menu: Menu)
}

class DrawerViewController: UIViewController, DrawerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selfNameView: UITextView!
    var selfNumberView: UITextView!
    var footerImageView: UIImageView!
    
    // Menu items
    var menus = AppDrawer.menuItems
    var homeViewController: UIViewController!
    var keyLocationsViewController: UIViewController!
    var pendingRequestsViewController: UIViewController!
    var settingsViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let keyLocationsViewController = storyboard.instantiateViewControllerWithIdentifier("KeyLocationsViewController") as! KeyLocationsViewController
        self.keyLocationsViewController = UINavigationController(rootViewController: keyLocationsViewController)
        
        let pendingRequestsViewController = storyboard.instantiateViewControllerWithIdentifier("PendingRequestsViewController") as! PendingRequestsViewController
        self.pendingRequestsViewController = UINavigationController(rootViewController: pendingRequestsViewController)
        
        let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
        self.settingsViewController = UINavigationController(rootViewController: settingsViewController)
        
        self.tableView.registerClass(DrawerTableViewCell.self, forCellReuseIdentifier: DrawerTableViewCell.identifier)
        self.tableView.alwaysBounceVertical = false
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        
        self.view.backgroundColor = ColorWheel.offWhite
        self.view.alpha = 1.0
        
        self.drawSelfNameView()
        self.drawSelfNumberView()
        self.drawHorizontalLineSeparator()
        self.drawFooterImageView()
    }
    
    /*
     * drawSelfNameView draws the current account name to the drawer
     */
    func drawSelfNameView() {
        self.selfNameView = UITextView()
        self.selfNameView.frame = CGRect(x: 0, y: 20, width: SlideMenuOptions.leftViewWidth, height: 40)
        self.selfNameView.editable = false
        self.selfNameView.userInteractionEnabled = false
        self.selfNameView.textContainer.lineFragmentPadding = 2*SizingConstants.spacingMargin
        
        self.selfNameView.backgroundColor = ColorWheel.transparent
        self.selfNameView.textColor = ColorWheel.darkGray
        self.selfNameView.font = FontStyle.h4
        self.selfNameView.text = AppDrawer.selfName
        
        self.view.addSubview(self.selfNameView)
    }
    
    /*
     * drawSelfNumberView draws the current account phone to the drawer
     */
    func drawSelfNumberView() {
        self.selfNumberView = UITextView()
        self.selfNumberView.frame = CGRect(x: 0, y: 60, width: SlideMenuOptions.leftViewWidth, height: 40)
        self.selfNumberView.editable = false
        self.selfNumberView.userInteractionEnabled = false
        self.selfNumberView.textContainer.lineFragmentPadding = 2*SizingConstants.spacingMargin
        
        self.selfNumberView.backgroundColor = ColorWheel.transparent
        self.selfNumberView.textColor = ColorWheel.darkGray
        self.selfNumberView.font = FontStyle.h4
        let fromPhoneNumber = NSUserDefaults.standardUserDefaults().stringForKey("phoneNumber")!
        self.selfNumberView.text = fromPhoneNumber
        
        self.view.addSubview(self.selfNumberView)
    }
    
    /*
     * drawHorizontalLineSeparator draws a separator between the header and the navigation table in the drawer
     */
    func drawHorizontalLineSeparator() {
        let separator = UIView(frame: CGRectMake(0, 100, SlideMenuOptions.leftViewWidth, 1))
        separator.backgroundColor = ColorWheel.darkGray
        self.view.addSubview(separator)
    }
    
    /*
     * drawFooterImageView draws the footer logo to the drawer
     */
    func drawFooterImageView() {
        let image = UIImage(named: UIFiles.sideBarLogo)
        self.footerImageView = UIImageView(image: image!)
        
        self.view.addSubview(self.footerImageView)
        self.footerImageView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self.footerImageView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.footerImageView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([widthConstraint, bottomConstraint])
    }
    
    func changeViewController(menu: Menu) {
        switch menu {
        case .Home:
            self.slideMenuController()?.changeMainViewController(self.homeViewController, close: true)
        case .KeyLocations:
            self.slideMenuController()?.changeMainViewController(self.keyLocationsViewController, close: true)
        case .PendingRequests:
            self.slideMenuController()?.changeMainViewController(self.pendingRequestsViewController, close: true)
        case .Settings:
            self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
        }
    }
}

extension DrawerViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let menu = Menu(rawValue: indexPath.item) {
            switch menu {
            case .Home, .KeyLocations, .PendingRequests, .Settings:
                return DrawerTableViewCell.height
            }
        }
        return 0
    }
}

extension DrawerViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let menu = Menu(rawValue: indexPath.item) {
            switch menu {
            case .Home, .KeyLocations, .PendingRequests, .Settings:
                let cell = DrawerTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: DrawerTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                
                let backgroundSelectionView = UIView()
                backgroundSelectionView.backgroundColor = ColorWheel.mediumGray
                cell.selectedBackgroundView = backgroundSelectionView
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = Menu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
}