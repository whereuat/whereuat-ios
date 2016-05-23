//
//  KeyLocationTableViewCell.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/14/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import UIKit

class KeyLocationTableViewCell : BaseTableViewCell {
    static var identifier = "KeyLocationTableViewCell"
    
    var delegate: KeyLocationsViewController!
    
    var titleView: UITextView!
    var subtitleView: UITextView!
    var deleteIconView: UIImageView!
    var editIconView: UIImageView!
    
    var keyLocation: KeyLocation!
    
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
    func setData(keyLocation: KeyLocation) {
        self.keyLocation = keyLocation
        
        titleView = self.makeTitleView(self.keyLocation.name)
        subtitleView = self.makeSubtitleView(String(self.keyLocation.latitude) + ", " + String(self.keyLocation.longitude))
        deleteIconView = self.makeRightOneIconView(Icons.delete)
        editIconView = self.makeRightTwoIconView(Icons.edit)
        
        self.addSubview(titleView)
        self.addSubview(subtitleView)
        self.addSubview(deleteIconView)
        self.addSubview(editIconView)
        
        let deleteGesture = UITapGestureRecognizer(target: self, action: #selector(KeyLocationTableViewCell.deleteAction(_:)))
        let editGesture = UITapGestureRecognizer(target: self, action: #selector(KeyLocationTableViewCell.editAction(_:)))
        
        deleteIconView.userInteractionEnabled = true
        deleteIconView.addGestureRecognizer(deleteGesture)
        editIconView.userInteractionEnabled = true
        editIconView.addGestureRecognizer(editGesture)
    }
    
    func editAction(sender: UITapGestureRecognizer) {
        // Fade the view out a little
        UIView.animateWithDuration(0.5) {
            self.editIconView.alpha = 0.5
        }
        // Fade the view back in
        UIView.animateWithDuration(0.5) {
            self.editIconView.alpha = 1.0
        }
        delegate.editKeyLocation(self.keyLocation.id!, currentName: self.keyLocation.name)
    }
    
    func deleteAction(sender: UITapGestureRecognizer) {
        // Fade the view out a little
        UIView.animateWithDuration(0.5) {
            self.deleteIconView.alpha = 0.5
        }
        // Fade the view back in
        UIView.animateWithDuration(0.5) {
            self.deleteIconView.alpha = 1.0
        }
        delegate.removeKeyLocation(self.keyLocation.id!)
    }
}
