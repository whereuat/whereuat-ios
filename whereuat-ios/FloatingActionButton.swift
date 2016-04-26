//
//  FloatingActionButton.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 4/14/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit
import LiquidFloatingActionButton

protocol FABDelegate : class {
    func addContact()
    func addKeyLocation()
}

class FloatingActionButton: LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate {
    
    var delegate: FABDelegate!
    
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    init(color: UIColor) {
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
        cells.append(cellFactory("ic_person_add"))
        
        // A FAB has an absolute positioning relative to the UI Main Screen
        let floatingFrame = CGRect(x: UIScreen.mainScreen().bounds.width - 56 - 16, y: UIScreen.mainScreen().bounds.height - 56 - 16, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        bottomRightButton.color = color
        
        self.floatingActionButton = bottomRightButton
    }
    
    
    @objc func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    @objc func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    @objc func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        switch index {
        case 0: // Add key location
            self.delegate.addKeyLocation()
        case 1: // Add contact
            self.delegate.addContact()
        default:
            print("Incorrect selection in floating action button")
        }
        liquidFloatingActionButton.close()
    }
    
}