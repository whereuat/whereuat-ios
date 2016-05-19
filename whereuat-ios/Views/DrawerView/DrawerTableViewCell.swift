//
//  DrawerCell.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/11/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import UIKit

public class DrawerTableViewCell : UITableViewCell {
    static var identifier = "DrawerTableViewCell"
    static var height:CGFloat = 64.0
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public override func awakeFromNib() {
    }
    
    public func setup() {
    }
    
    /*
     * setData sets the contents of a nav item in the drawer
     * @param data - Any object that carrys the payload. The data can be found in Globals.
     */
    public func setData(data: Any?) {
        self.backgroundColor = ColorWheel.transparent
        self.textLabel!.font = FontStyle.h4
        self.textLabel!.textColor = ColorWheel.darkGray
        if let menuData = data as? Array<String> {
            // Set the icon
            let icon = UIImage(named: menuData[1])
            let iconView = UIImageView(frame: CGRect(x: 10, y: 15, width: 30, height: 30))
            iconView.image = icon
            iconView.image = iconView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            iconView.tintColor = ColorWheel.darkGray
            
            // Set the text
            let textView = UITextView(frame: CGRect(x: 50, y: 12, width: 200, height: 64))
            textView.text = menuData[0]
            textView.font = FontStyle.h4
            textView.textColor = ColorWheel.darkGray
            textView.backgroundColor = ColorWheel.transparent
            textView.selectable = false
            textView.editable = false
            textView.userInteractionEnabled = false
            
            self.addSubview(iconView)
            self.addSubview(textView)
        }
    }
}
