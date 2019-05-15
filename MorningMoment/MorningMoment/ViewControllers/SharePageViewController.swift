//
//  SharePageViewController.swift
//  MorningMoment
//
//  Created by Alex Nguyen on 5/2/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import Contacts

protocol SharePageViewControllerDelegate: class {
	
	func SharePageViewControllerDidBack();
}

class SharePageViewController: UIViewController {
	var CDJournal : [CDJournalPage]!
	var ShareVC: ShareViewController!
	var page: CDJournalPage!
	var image:UIImage!
	weak var delegate: SharePageViewControllerDelegate?
	@IBOutlet weak var let_go: UITextField!
	@IBOutlet weak var grateful_1: UITextField!
	@IBOutlet weak var grateful_2: UITextField!
	@IBOutlet weak var grateful_3: UITextField!
	@IBOutlet weak var focus_1: UITextField!
	@IBOutlet weak var focus_2: UITextField!
    @IBOutlet weak var mood_display: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		let_go.isEnabled = false;
		grateful_1.isEnabled = false;
		grateful_2.isEnabled = false;
		grateful_3.isEnabled = false;
		focus_1.isEnabled = false;
		focus_2.isEnabled = false;
        mood_display.isHidden = false;
		loadPage(p:page)
        // Do any additional setup after loading the view.
    }
	
	func setPage(p: CDJournalPage){
        page = p
        if isViewLoaded{
			let_go.text = page.let_go_text
			grateful_1.text = page.grateful_1_text
			grateful_2.text = page.grateful_2_text
			grateful_3.text = page.grateful_3_text
			focus_1.text = page.focus_1_text
			focus_2.text = page.focus_2_text
            
            // set mood emoji
            let mood = Int(page.mood)
            var image = UIImage(named: "0_emoji");
            switch (mood) {
            case 1: image = UIImage(named: "1_emoji"); break;
            case 2: image = UIImage(named: "2_emoji"); break;
            case 3: image = UIImage(named: "3_emoji"); break;
            case 4: image = UIImage(named: "4_emoji"); break;
            case 5: image = UIImage(named: "5_emoji"); break;
            case 6: image = UIImage(named: "6_emoji"); break;
            case 7: image = UIImage(named: "7_emoji"); break;
            case 8: image = UIImage(named: "8_emoji"); break;
            default: break;
            }
            mood_display.image = image;
        }
	}
	
	func loadPage(p:CDJournalPage){
		let_go.text = p.let_go_text
		grateful_1.text = p.grateful_1_text
		grateful_2.text = p.grateful_2_text
		grateful_3.text = p.grateful_3_text
		focus_1.text = p.focus_1_text
		focus_2.text = p.focus_2_text
        
        // set mood emoji
        let mood = Int(page.mood)
        var image = UIImage(named: "0_emoji");
        switch (mood) {
            case 1: image = UIImage(named: "1_emoji"); break;
            case 2: image = UIImage(named: "2_emoji"); break;
            case 3: image = UIImage(named: "3_emoji"); break;
            case 4: image = UIImage(named: "4_emoji"); break;
            case 5: image = UIImage(named: "5_emoji"); break;
            case 6: image = UIImage(named: "6_emoji"); break;
            case 7: image = UIImage(named: "7_emoji"); break;
            case 8: image = UIImage(named: "8_emoji"); break;
        default: break;
        }
        mood_display.image = image;
	}
	

	@IBAction func screenShotClicked(_ sender: Any) {
        
		//Create the UIImage
		UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
		guard let context = UIGraphicsGetCurrentContext() else { return }
		view.layer.render(in: context)
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext()

		//Save it to the camera roll
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

		let status = CNContactStore.authorizationStatus(for: .contacts)
		if status == .denied || status == .restricted {
			presentSettingsActionSheet()
			return
		}
		
		// open it
			
			self.performSegue(withIdentifier: "contactsSegue", sender: self)
		
	}
	
	func presentSettingsActionSheet() {
		let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
			let url = URL(string: UIApplication.openSettingsURLString)!
			UIApplication.shared.open(url)
		})
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(alert, animated: true)
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let ContactsVC:ContactsViewController = segue.destination as! ContactsViewController
		ContactsVC.image = image
	}

    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: self.delegate?.SharePageViewControllerDidBack);
    }
    
}

