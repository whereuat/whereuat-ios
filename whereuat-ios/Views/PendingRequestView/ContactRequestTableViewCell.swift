//
//  ContactRequestTableViewCell.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/16/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import Foundation

class ContactRequestTableViewCell: BaseTableViewCell {
    static var identifier = "ContactRequestTableViewCell"
    
    var delegate: ContactRequestsViewController!
    
    var titleView: UITextView!
    var subtitleView: UITextView!
    var deleteIconView: UIImageView!
    var addIconView: UIImageView!
    
    var hasName = true
    
    var contactRequest: Contact!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    /*
     * setData sets the contents of a table via its cells
     * @param data - Any object that carrys the payload.
     */
    func setData(contact: Contact) {
        self.contactRequest = contact
        if (contactRequest.getName().characters.count == 1 || contactRequest.getName() == " ") {
            hasName = false
        }
        
        // The name of the contact has not been identified, show just the phone number in the title
        // otherwise, show the contact's name in the title and the phone number in the subtitle
        if hasName {
            titleView = self.makeTitleView(self.contactRequest.getName())
            subtitleView = self.makeSubtitleView(self.contactRequest.phoneNumber)
        } else {
            titleView = self.makeTitleView(self.contactRequest.phoneNumber)
            subtitleView = self.makeSubtitleView("")
        }
        deleteIconView = self.makeRightOneIconView(Icons.delete)
        addIconView = self.makeRightTwoIconView(Icons.contactAdd)
        
        self.addSubview(titleView)
        self.addSubview(subtitleView)
        self.addSubview(deleteIconView)
        self.addSubview(addIconView)
        
        let deleteGesture = UITapGestureRecognizer(target: self, action: #selector(KeyLocationTableViewCell.deleteAction(_:)))
        let addGesture = UITapGestureRecognizer(target: self, action: #selector(ContactRequestTableViewCell.addAction(_:)))
        
        deleteIconView.userInteractionEnabled = true
        deleteIconView.addGestureRecognizer(deleteGesture)
        addIconView.userInteractionEnabled = true
        addIconView.addGestureRecognizer(addGesture)
    }
    
    func addAction(sender: UITapGestureRecognizer) {
        // Fade the view out a little
        UIView.animateWithDuration(0.5) {
            self.addIconView.alpha = 0.5
        }
        // Fade the view back in
        UIView.animateWithDuration(0.5) {
            self.addIconView.alpha = 1.0
        }
        delegate.addContactRequestToContacts(self.contactRequest, hasName: self.hasName)
    }
    
    func deleteAction(sender: UITapGestureRecognizer) {
        // Fade the view out a little
        UIView.animateWithDuration(0.5) {
            self.addIconView.alpha = 0.5
        }
        // Fade the view back in
        UIView.animateWithDuration(0.5) {
            self.addIconView.alpha = 1.0
        }
        delegate.removeContactRequest(self.contactRequest)
    }

}