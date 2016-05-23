//
//  FloatingActionButton.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 4/14/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit
import LiquidFloatingActionButton

@objc protocol FABDelegate : class {
    optional func addContact()
    optional func addKeyLocation()
}

/*
 * FABType represents two types of notifications, alerts and push notifications
 */
enum FABType {
    case Main
    case KeyLocationOnly
}

/*
 * FloatingActionButton manages a floating action button for whereu@
 */
class FloatingActionButton: LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate {
    
    var delegate: FABDelegate!
    
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    var type: FABType!
    
    /*
     * init creates the floating action button
     * @param color - the color to be drawn
     */
    init(color: UIColor, type: FABType) {
        self.type = type
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            return LiquidFloatingCell(icon: UIImage(named: iconName)!)
        }
        cells.append(cellFactory("ic_add_location"))
        if (self.type == FABType.Main) {
            cells.append(cellFactory("ic_person_add"))
        }
        
        // A FAB has an absolute positioning relative to the UI Main Screen
        let floatingFrame = CGRect(x: UIScreen.mainScreen().bounds.width - 56 - 16, y: UIScreen.mainScreen().bounds.height - 56 - 16, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        bottomRightButton.color = color
        
        self.floatingActionButton = bottomRightButton
    }
    
    /*
     * numberOfCells gets the number of items in the FAB
     * @param liquidFloatingActionButton - the target FAB
     * @return the number of cells
     */
    @objc func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    @objc func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    /*
     * liquidFloatingActionButton handles the selection of items in the FAB
     */
    @objc func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        if self.type == FABType.Main {
            switch index {
            case 0: // Add key location
                self.delegate.addKeyLocation!()
            case 1: // Add contact
                self.delegate.addContact!()
            default:
                print("Incorrect selection in floating action button")
            }
        }
        else if self.type == FABType.KeyLocationOnly {
            switch index {
            case 0: // Add key location
                self.delegate.addKeyLocation!()
            default:
                print("Incorrect selection in floating action button")
            }
        }
        liquidFloatingActionButton.close()
    }
}
