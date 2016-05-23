//
//  KeyLocationsViewController.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/11/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import UIKit

class KeyLocationsViewController: UIViewController, FABDelegate {
    
    var database = Database.sharedInstance
    
    var mainFAB: FloatingActionButton!
    
    @IBOutlet weak var tableView: UITableView!
    var keyLocations: Array<KeyLocation>!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch key locations from the database
        keyLocations = self.database.keyLocationTable.getAll() as! Array<KeyLocation>
        
        self.tableView.registerClass(KeyLocationTableViewCell.self, forCellReuseIdentifier: KeyLocationTableViewCell.identifier)
        self.tableView.alwaysBounceVertical = false
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, SizingConstants.tableBottomPadding, 0);
        
        // Draw the FAB to appear on the bottom right of the screen
        self.mainFAB = FloatingActionButton(color: ColorWheel.coolRed, type: FABType.KeyLocationOnly)
        self.mainFAB.delegate = self
        self.view.addSubview(self.mainFAB.floatingActionButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItems("Key Locations")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return KeyLocationTableViewCell.height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (keyLocations != nil) {
            return keyLocations!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (keyLocations != nil) {
            let cell = KeyLocationTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: KeyLocationTableViewCell.identifier)
            cell.setData(keyLocations![indexPath.row])
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func reloadTableData() {
        // Fetch key locations from the database
        self.keyLocations = self.database.keyLocationTable.getAll() as! Array<KeyLocation>
        self.tableView.reloadData()
    }
    
    /*
     * editKeyLocation spawns a content popup with the key location name as editable
     */
    func editKeyLocation(id: Int64, currentName: String) {
        let alert = ContentPopup.editKeyLocationAlert(id, currentName: currentName, refreshCallback: self.reloadTableData)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
     * removeKeyLocation drops a key location from the database
     */
    func removeKeyLocation(id: Int64) {
        self.database.keyLocationTable.dropKeyLocation(id)
        self.reloadTableData()
    }
    
    /*
     * addKeyLocation spawns an alert with a text view and adds the key location to the database
     * addKeyLocation is invoked by the floating action button
     */
    func addKeyLocation() {
        self.presentViewController(ContentPopup.addKeyLocationAlert(self.reloadTableData), animated: true, completion: nil)
    }
}
