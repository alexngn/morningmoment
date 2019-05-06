//
//  ContactsViewController.swift
//  MorningMoment
//
//  Created by Owner on 5/3/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import Contacts
import MessageUI
protocol ContactsViewControllerDelegate: class {
	
	func ContactsViewControllerDidBack();
}

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate{

	weak var delegate: ContactsViewControllerDelegate?
	var image: UIImage!
	let store = CNContactStore()
	var contacts = [CNContact]()
	let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as NSString, CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor])
	@IBOutlet weak var table: UITableView!
	@IBAction func send(_ sender: Any) {

		
	}
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
        
        // do something with the contacts array (e.g. print the names)
        
        
        // Do any additional setup after loading the view.
    }
	
	@IBAction func backButtonClicked(_ sender: Any) {
		self.dismiss(animated: true, completion: self.delegate?.ContactsViewControllerDidBack);
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contacts.count;
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let composeVC = MFMessageComposeViewController()
		composeVC.messageComposeDelegate = self
		
		print(indexPath.row)
		
		let number = (contacts[indexPath.row].phoneNumbers[0].value ).value(forKey: "digits") as! String

		
		print(number)
		// Configure the fields of the interface.
		composeVC.recipients = [number]
		composeVC.addAttachmentData(image.jpegData(compressionQuality: CGFloat(1.0))!, typeIdentifier: "image/jpeg", filename: "JournalScreenShot.jpeg")
		
		// Present the view controller modally.
		if MFMessageComposeViewController.canSendText() {
			self.present(composeVC, animated: true, completion: nil)
		} else {
			print("Can't send messages.")
		}

	}
	
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

