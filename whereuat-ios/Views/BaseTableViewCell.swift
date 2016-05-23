//
//  BaseTableViewCell.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/14/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import UIKit

class BaseTableViewCell : UITableViewCell {
    static var height:CGFloat = 72.0
    let iconSize:CGFloat = 30.0
    let cellPadding:CGFloat = 15.0
    
    func makeTitleView(title: String) -> UITextView {
        let titleView = UITextView(frame: CGRect(x: cellPadding, y: 10, width: 200, height: 48.0))
        titleView.text = title
        titleView.font = FontStyle.h4
        titleView.textColor = ColorWheel.coolRed
        titleView.backgroundColor = ColorWheel.transparent
        titleView.selectable = false
        titleView.editable = false
        titleView.userInteractionEnabled = false
        return titleView
    }
    
    func makeSubtitleView(subtitle: String) -> UITextView {
        let subtitleView = UITextView(frame: CGRect(x: cellPadding, y: 30, width: 200, height: 24.0))
        subtitleView.text = subtitle
        subtitleView.font = FontStyle.smallRegular
        subtitleView.textColor = ColorWheel.darkGray
        subtitleView.backgroundColor = ColorWheel.transparent
        subtitleView.selectable = false
        subtitleView.editable = false
        subtitleView.userInteractionEnabled = false
        return subtitleView
    }
    
    /*
     * Return an iconview positioned at the rightmost spot of the cell
     */
    func makeRightOneIconView(iconName: String) -> UIImageView {
        let iconView = UIImageView(frame: CGRect(x: self.frame.width - iconSize - cellPadding, y: 22, width: iconSize, height: iconSize))
        iconView.image = UIImage(named: iconName)
        iconView.image = iconView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        iconView.tintColor = ColorWheel.darkGray
        return iconView
    }
    
    /*
     * Return an iconview positioned at the second to rightmost spot of the cell
     */
    func makeRightTwoIconView(iconName: String) -> UIImageView {
        let iconView = UIImageView(frame: CGRect(x: self.frame.width - 2*iconSize - cellPadding - 5, y: 22, width: iconSize, height: iconSize))
        iconView.image = UIImage(named: iconName)
        iconView.image = iconView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        iconView.tintColor = ColorWheel.darkGray
        return iconView
    }
    
    // Ignore the default selection handling
    override func setSelected(selected: Bool, animated: Bool) {
    }
    override func setHighlighted(highlighted: Bool, animated: Bool) {
    }
}
