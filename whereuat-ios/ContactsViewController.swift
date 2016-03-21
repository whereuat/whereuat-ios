//
//  ContactsViewControllerCollectionViewController.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 2/10/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ContactsViewController: UICollectionViewController {

    private let reuseIdentifier = "ContactCell"
    
    var contactData = ["PK", "JA", "SW", "RJ", "RM", "SR", "PP"]

    var buttonContainer: UIView!
    var addContactButton: PushButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        
        self.drawAddContactButton()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contactData.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // The ideal cell size is 182.5 (two squares side by side on the iPhone 6S)
        let screenWidth = UIScreen.mainScreen().bounds.width
        let idealCellSize = 182.5
        // Calculate the number of cells to display horizontally based on a rounding of how
        // many times the idealCellSize can fit into the screen width
        let numCells = Int(round(Double(screenWidth) / idealCellSize))
        let cellSize = screenWidth / CGFloat(numCells)
        return CGSizeMake(cellSize, cellSize);
    }
    
    func drawAddContactButton() {
        self.buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.buttonContainer.backgroundColor = UIColor.blackColor()
        self.addContactButton = PushButtonView()
        self.addContactButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        self.addContactButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.addContactButton.layer.shadowOffset = CGSizeMake(3, 3)
        self.addContactButton.layer.shadowRadius = 2
        self.addContactButton.layer.shadowOpacity = 0.3
        self.addContactButton.layer.shadowPath = UIBezierPath(roundedRect: self.addContactButton.bounds, cornerRadius: 100.0).CGPath
        
        self.buttonContainer.addSubview(self.addContactButton)
        self.view.addSubview(self.buttonContainer)
        
        self.buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = NSLayoutConstraint(item: self.buttonContainer, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -8*SizingConstants.spacingMargin)
        let rightContstraint = NSLayoutConstraint(item: self.buttonContainer, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -8*SizingConstants.spacingMargin)
        self.view.addConstraints([bottomConstraint, rightContstraint])
    }

}