//
//  ContactViewCell.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 3/23/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit

class ContactViewCell: UICollectionViewCell {
    
    var delegate: ContactsViewController!
    var contactView: ContactView!
    
    var contactData: Contact!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
     * addContactView loads the contact data into the contact view and constrains it
     */
    func addContactView() {
        self.contactView.delegate = self.delegate
    
        self.contentView.addSubview(self.contactView)
        self.contactView.translatesAutoresizingMaskIntoConstraints = false
        let leftSideConstraint = NSLayoutConstraint(item: self.contactView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.contactView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: self.contactView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: self.contactView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: 0.0)
        self.addConstraints([leftSideConstraint, bottomConstraint, widthConstraint, heightConstraint])
    }
    
    /*
     * prepareForReuse is called when the cell leaves the screen.
     * The contact view is removed from the superview to prevent duplicate drawing
     */
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contactView.removeFromSuperview()
    }
}
