//
//  ContactsViewControllerCollectionViewController.swift
//  whereuat-ios
//
//  Created by Raymond Jacobson on 2/10/16.
//  Copyright © 2016 whereu@. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import CoreLocation

class ContactsViewController: UICollectionViewController, CNContactPickerDelegate, FABDelegate {

    private let reuseIdentifier = "ContactViewCell"
    
    // Set up Databases as Singletons
    var database: Database!
    
    var contactData: Array<Contact>!
    var keyLocationData: Array<KeyLocation>!

    var mainFAB: FloatingActionButton!
    
    var contactViews: Array<ContactView>!
    
    override func viewDidLoad() {      
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)

        // Load mock data into contactData array
        database = Database.sharedInstance
        self.contactData = database.contactTable.getAll() as! Array<Contact>
        self.keyLocationData = database.keyLocationTable.getAll() as! Array<KeyLocation>
        
        // Preload contact views so they just need to be loaded into cells on display
        self.contactViews = []
        for contact in self.contactData {
            self.contactViews.append(ContactView(contactData: contact))
        }
        
        // Draw the FAB to appear on the bottom right of the screen
        self.mainFAB = FloatingActionButton(color: ColorWheel.coolRed, type: FABType.Main)
        self.mainFAB.delegate = self
        self.view.addSubview(self.mainFAB.floatingActionButton)
        self.setNavigationBarItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItems()
        self.contactData = database.contactTable.getAll() as! Array<Contact>
        // Preload contact views so they just need to be loaded into cells on display
        self.contactViews = []
        for contact in self.contactData {
            self.contactViews.append(ContactView(contactData: contact))
        }
        self.collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contactData.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> ContactViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ContactViewCell
        cell.delegate = self
        cell.contactData = self.contactData[indexPath.row]
        cell.contactView = self.contactViews[indexPath.row]
        
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            cell.addContactView()
        })
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
        return CGSizeMake(cellSize, cellSize)
    }
    
    /*
     * addContact gets a contact and delegates its work to the system contact picker
     */
    func addContact() {
        // Ensure user hasn't previously denied contact access
        let status = CNContactStore.authorizationStatusForEntityType(.Contacts)
        if status == .Denied || status == .Restricted {
            // user previously denied, so tell them to fix that in settings
            return
        }
        
        // Change to contact view
        let controller = CNContactPickerViewController()
        controller.delegate = self
        self.presentViewController(controller,
            animated: true, completion: nil)
    }
    
    /*
     * contactPicker gets a contact from the system contact picker, inserts it into the database,
     * and appends the contact to the data
     */
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        // Get the total number of already drawn contacts
        let contactCount = self.contactData.count
        if contact.isKeyAvailable(CNContactPhoneNumbersKey){
            // If the contact has a mobile phone number, add the contact (and first mobile number) to the database
            // Otherwise we do nothing
            for phoneNumber in contact.phoneNumbers {
                let countryCodeLookup: [String: String] = [
                     "us": "1"
                ]
                // TODO: Put this in a constant
                if (phoneNumber.label == "_$!<Mobile>!$_") {
                    var formattedNumberString = ""
                    let number = phoneNumber.value as! CNPhoneNumber
                    let countryCode = number.valueForKey("countryCode") as! String
                    let numberString = number.valueForKey("digits") as! String
                    // Check if the user already has +1 prepended before a cell phone number
                    if !numberString.hasPrefix("+1") {
                        formattedNumberString += "+"
                        formattedNumberString += countryCodeLookup[countryCode]!
                    }
                    formattedNumberString += numberString
                    if (Database.sharedInstance.contactTable.getContact(formattedNumberString) == nil) {
                        let newContact = Contact(firstName: contact.givenName, lastName: contact.familyName, phoneNumber: formattedNumberString, autoShare: false, requestedCount: 0, color: ColorWheel.randomColor())
                        self.contactData.append(newContact)
                        self.contactViews.append(ContactView(contactData: newContact))
                        self.database.contactTable.insert(newContact)
                        self.collectionView!.insertItemsAtIndexPaths([NSIndexPath(forRow: contactCount, inSection: 0)])
                    }
                    break
                }
            }
        }
    }
    
    /*
     * addKeyLocation spawns an alert with a text view and adds the key location to the database
     */
    func addKeyLocation() {
        self.presentViewController(ContentPopup.addKeyLocationAlert(), animated: true, completion: nil)
    }
}
