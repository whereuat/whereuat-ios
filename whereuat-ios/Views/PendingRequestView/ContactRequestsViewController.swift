//
//  ContactRequestsViewController.swift
//  whereuat
//
//  Created by Raymond Jacobson on 5/11/16.
//  Copyright © 2016 whereuat. All rights reserved.
//

import UIKit
import JLToast

class ContactRequestsViewController: UIViewController {
    
    var database = Database.sharedInstance

    @IBOutlet weak var tableView: UITableView!
    var contactRequests: Array<Contact>!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch key locations from the database
        contactRequests = self.database.contactRequestTable.getAll() as! Array<Contact>
        
        self.tableView.registerClass(KeyLocationTableViewCell.self, forCellReuseIdentifier: KeyLocationTableViewCell.identifier)
        self.tableView.alwaysBounceVertical = false
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, SizingConstants.tableBottomPadding, 0)
        self.setNavigationBarItems("Contact Requests")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItems("Contact Requests")
        self.reloadTableData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return KeyLocationTableViewCell.height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (contactRequests != nil) {
            return contactRequests!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (contactRequests != nil) {
            let cell = ContactRequestTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ContactRequestTableViewCell.identifier)
            cell.setData(contactRequests![indexPath.row])
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func reloadTableData() {
        // Fetch key locations from the database
        self.contactRequests = self.database.contactRequestTable.getAll() as! Array<Contact>
        self.tableView.reloadData()
    }
    
    /*
     * addContactRequestToContact drops a contact from the pending requests and adds it as a contact.
     * If the contact has no name, a dialog is opened to ask the user to input a name
     * @param contact - the contact to be added
     * @param hasName - a boolean flag. True signals that the contact has a name and is primed for adding
     */
    func addContactRequestToContacts(contact: Contact, hasName: Bool) {
        if hasName {
            JLToast.makeText(Language.contactAdded).show()
            database.contactRequestTable.dropContactRequest(contact.phoneNumber)
            database.contactTable.insert(contact)
            self.reloadTableData()
        } else {
            // Present view controller handles database insertion and deletion as the cancel action
            // should not trigger a database drop on the contactRequestTable
            self.presentViewController(ContentPopup.addContactWithNewNameAlert(contact.phoneNumber,
                                                                               refreshCallback: self.reloadTableData),
                                                                               animated: true, completion: nil)
        }
    }
    
    /*
     * removeContactRequest drops the pending request from the list of pending requests
     */
    func removeContactRequest(contact: Contact) {
        database.contactRequestTable.dropContactRequest(contact.phoneNumber)
        self.reloadTableData()
    }
}
