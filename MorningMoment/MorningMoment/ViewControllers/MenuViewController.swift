//
//  MenuViewController.swift
//  MorningMoment
//
//  Created by Thea Birk Berger on 4/22/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol MenuViewControllerDelegate: class {
    func MenuViewControllerDidBack();
}


public class MenuViewController: UIViewController{
    
    // CLASS PROPERTIES
    weak var delegate: MenuViewControllerDelegate?
    var menu_color = UIColor.init(red: 0.964, green: 1, blue: 0.908, alpha: 1);
    var JournalPageVC: JournalPageViewController!
    @IBOutlet weak var menu_label: UILabel!
    @IBOutlet weak var share_journal_button: UIButton!
    @IBOutlet weak var explore_mood_button: UIButton!
    @IBOutlet weak var explore_activity_button: UIButton!
    @IBOutlet weak var delete_pages_button: UIButton!
    @IBOutlet weak var about_button: UIButton!
    @IBOutlet weak var settings_button: UIButton!
    var CDJournal: [CDJournalPage]!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = menu_color
        
        // set menu option tags
        self.share_journal_button.tag = 0;
        self.explore_mood_button.tag = 1;
        self.explore_activity_button.tag = 2;
        self.delete_pages_button.tag = 3;
        self.about_button.tag = 4;
        self.settings_button.tag = 5;
    }
    
    // back button clicked: return to journal
    @IBAction func backButtonClicked (sender: Any) {
        
        self.dismiss(animated: true, completion: self.delegate?.MenuViewControllerDidBack);
    }
    
    // menu option clicked: perform corresponding segue
    @IBAction func menuOptionClicked(_ sender: AnyObject) {
        
        switch (sender.tag) {
            
        case 0: performSegue(withIdentifier: "ShareJournalSegue", sender: self)
        break;
        case 1: performSegue(withIdentifier: "ExploreMoodSegue", sender: self)
        break;
        case 2: performSegue(withIdentifier: "ExploreActivitySegue", sender: self)
        break;
        case 3: performSegue(withIdentifier: "DeletePagesSegue", sender: self)
        break;
        case 4: performSegue(withIdentifier: "AboutSegue", sender: self)
        break;
        case 5: performSegue(withIdentifier: "SettingsSegue", sender: self)
        break;
        default: break;
        }
    }
    
    // when a segue is performed to another view: transfer some data from menu
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShareJournalSegue"{
            let ShareJournalMC = segue.destination as! ShareViewController
            ShareJournalMC.CDJournal = self.CDJournal
        }
        else if segue.identifier == "DeletePagesSegue"{
            let DeletePageMC = segue.destination as! DeleteViewController
            DeletePageMC.CDJournal = self.CDJournal
        }
        else if segue.identifier == "ExploreMoodSegue"{
            let destination = segue.destination as? MoodViewController
            destination?.CDJournal = self.CDJournal
        }
        else if segue.identifier == "ExploreActivitySegue"{
            let destination = segue.destination as? ActivityViewController
            destination?.CDJournal = self.CDJournal
        }
        else if segue.identifier == "SettingsSegue"{
            let SettingsMC = segue.destination as! SettingsViewController
            //SettingsMC.journal_theme = self.journal_theme
            SettingsMC.JournalPageVC = self.JournalPageVC
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        
        // extract journal from CoreData
        let fetchRequest: NSFetchRequest<CDJournalPage> = CDJournalPage.fetchRequest()
        
        // update the local journal object with the CoreData journal
        do {
            let CDJournal = try PersistanceService.context.fetch(fetchRequest)
            self.CDJournal = CDJournal
        } catch{}
        
    }
    
}

