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

private let reuseIdentifier = "Cell"

class ContactsViewController: UICollectionViewController, CNContactPickerDelegate, CLLocationManagerDelegate{

    private let reuseIdentifier = "ContactCell"
    let locationManager = CLLocationManager()
    
    // Set up Database as Singleton
    var contactDatabase = ContactDatabase.sharedInstance
    
    var contactData: Array<Contact>!

    var buttonContainer: UIView!
    var addContactButton: PushButtonView!
    
    override func viewDidLoad() {
        
        self.collectionView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)

        // Load mock data into contactData array
        self.contactData = self.contactDatabase.getContacts()
        
        self.drawAddContactButton()
        
        // Grant location permissions
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contactData.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> ContactViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ContactViewCell
        cell.contactData = self.contactData[indexPath.row]
        cell.addContactView()
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
        return CGSizeMake(cellSize, cellSize);
    }
    
    func drawAddContactButton() {
        // Draw the add contact button
        self.buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.addContactButton = PushButtonView()
        self.addContactButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        self.addContactButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.addContactButton.layer.shadowOffset = CGSizeMake(3, 3)
        self.addContactButton.layer.shadowRadius = 2
        self.addContactButton.layer.shadowOpacity = 0.3
        self.addContactButton.layer.shadowPath = UIBezierPath(roundedRect: self.addContactButton.bounds, cornerRadius: 100.0).CGPath
        
        // Add the button to the button container
        self.buttonContainer.addSubview(self.addContactButton)
        let bottomButtonConstraint = NSLayoutConstraint(item: self.addContactButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.buttonContainer, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let rightButtonConstraint = NSLayoutConstraint(item: self.addContactButton, attribute: .Right, relatedBy: .Equal, toItem: self.buttonContainer, attribute: .Right, multiplier: 1.0, constant: 0.0)
        self.buttonContainer.addConstraints([bottomButtonConstraint, rightButtonConstraint])
        
        self.buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        // Click event handler for add contact
        self.addContactButton.userInteractionEnabled = true
        self.addContactButton.becomeFirstResponder()
        let tap = UITapGestureRecognizer(target: self, action: Selector("addContact:"))
        self.addContactButton.addGestureRecognizer(tap)
        
        // Add the button container to the parent view and constrain it
        self.view.addSubview(self.buttonContainer)
        let bottomConstraint = NSLayoutConstraint(item: self.buttonContainer, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -2*SizingConstants.spacingMargin)
        let rightContstraint = NSLayoutConstraint(item: self.buttonContainer, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: -2*SizingConstants.spacingMargin)
        self.view.addConstraints([bottomConstraint, rightContstraint])

    }
    
    func addContact(sender: UITapGestureRecognizer) {
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
                if (phoneNumber.label == "_$!<Mobile>!$_") {
                    let number = phoneNumber.value as! CNPhoneNumber
                    let countryCode = number.valueForKey("countryCode") as! String
                    let numberString = number.valueForKey("digits") as! String
                    var formattedNumberString = "+"
                    formattedNumberString += countryCodeLookup[countryCode]!
                    formattedNumberString += numberString
                    let newContact = Contact(firstName: contact.givenName, lastName: contact.familyName, phoneNumber: formattedNumberString, autoShare: false, requestedCount: 0, color: ColorWheel.randomColor())
                    self.contactData.append(newContact)
                    self.contactDatabase.insertContact(newContact)
                    self.collectionView!.insertItemsAtIndexPaths([NSIndexPath(forRow: contactCount, inSection: 0)])
                    break
                }
            }
        }
    }

}