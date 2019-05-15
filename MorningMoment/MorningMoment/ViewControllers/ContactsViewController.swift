//
//  ContactsViewController.swift
//  MorningMoment
//
//  Created by Alex Nguyen on 5/3/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import Contacts
import MessageUI
protocol ContactsViewControllerDelegate: class {
    
    func ContactsViewControllerDidBack();
}

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate{
    
    // CLASS PROPERTIES
    weak var delegate: ContactsViewControllerDelegate?
    var image: UIImage!
    let store = CNContactStore()
    var contacts = [CNContact]()
    let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as NSString, CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor])
    @IBOutlet weak var table: UITableView!
    @IBAction func send(_ sender: Any) {
        
    }
    
    // sort and add list of contacts into array
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        request.sortOrder = CNContactSortOrder.userDefault
        
        do {
            try store.enumerateContacts(with: request) {
                contact, stop in self.contacts.append(contact)
                if contact.phoneNumbers.count == 0{
                    self.contacts.remove(at: (self.contacts.count-1))
                }
            }
        } catch {
            print(error)
        }
    }
    
    // back button clicked: return to share page
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: self.delegate?.ContactsViewControllerDidBack);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count;
    }
    
    // open iMessage with recipient as selected cell and attach screenshot to message body
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        print(indexPath.row)
        
        let number = (contacts[indexPath.row].phoneNumbers[0].value ).value(forKey: "digits") as! String
        
        print(number)
        
        // configure the fields of the interface.
        composeVC.recipients = [number]
        composeVC.addAttachmentData(image.jpegData(compressionQuality: CGFloat(1.0))!, typeIdentifier: "image/jpeg", filename: "JournalScreenShot.jpeg")
        
        // present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    // fill contacts table with names from contacts
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        cell.textLabel?.text = formatter.string(from: contacts[indexPath.row]) ?? "???"
        return cell
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

