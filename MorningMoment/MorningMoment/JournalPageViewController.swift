//
//  ViewController.swift
//  MorningMoment
//
//  Created by Thea Birk Berger on 4/10/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class JournalPageViewController: UIViewController {

    // CLASS PROPERTIES
    var Journal: NSMutableArray = [JournalPage()];
    let pageColour = UIColor.init(red: 0.202, green: 0.238, blue: 0.229, alpha: 1.0);
    var current_page_index_shown = 0;
    var current_date: String!
    
    // labels
    @IBOutlet weak var let_go_label: UILabel!
    @IBOutlet weak var grateful_label: UILabel!
    @IBOutlet weak var focus_label: UILabel!
    @IBOutlet weak var bul11_label: UILabel!
    @IBOutlet weak var bul12_label: UILabel!
    @IBOutlet weak var bul13_label: UILabel!
    @IBOutlet weak var bul21_label: UILabel!
    @IBOutlet weak var bul22_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    
    
    // textfields
    @IBOutlet weak var let_go_field: UITextField!
    @IBOutlet weak var grateful_field_1: UITextField!
    @IBOutlet weak var grateful_field_2: UITextField!
    @IBOutlet weak var grateful_field_3: UITextField!
    @IBOutlet weak var focus_field_1: UITextField!
    @IBOutlet weak var focus_field_2: UITextField!
    
    //
    
    
    // CLASS METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background color
        view.backgroundColor = pageColour;
        
        // set textfield tags
        self.let_go_field.tag = 0;
        self.grateful_field_1.tag = 1;
        self.grateful_field_2.tag = 2;
        self.grateful_field_3.tag = 3;
        self.focus_field_1.tag = 4;
        self.focus_field_2.tag = 5;
        
        self.current_page_index_shown = 0;
        
        // update date
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.current_date = dateFormatter.string(from: date);
        
    }
    
    func displayJournalPage () {
        
        // extract current page shown
        let journal_page = self.Journal.object(at: current_page_index_shown) as! JournalPage;
        
        let_go_field.text = journal_page.let_go_text;
        grateful_field_1.text = journal_page.grateful_1_text;
        grateful_field_2.text = journal_page.grateful_2_text;
        grateful_field_3.text = journal_page.grateful_3_text;
        focus_field_1.text = journal_page.focus_1_text;
        focus_field_2.text = journal_page.focus_2_text;
        date_label.text = current_date;
        
    }
    
    func clearTextFields () {
        
        let_go_field.text = "";
        grateful_field_1.text = "";
        grateful_field_2.text = "";
        grateful_field_3.text = "";
        focus_field_1.text = "";
        focus_field_2.text = "";
        
    }
    
    func enableTextFields (b: Bool) {
        
        let_go_field.isEnabled = b;
        grateful_field_1.isEnabled = b;
        grateful_field_2.isEnabled = b;
        grateful_field_3.isEnabled = b;
        focus_field_1.isEnabled = b;
        focus_field_2.isEnabled = b;
    }
    
    @IBAction func submitButtonPushed (sender: Any) {
        
        let journal_page = JournalPage();
        
        journal_page.let_go_text = let_go_field.text ?? "";
        journal_page.grateful_1_text = grateful_field_1.text ?? "";
        journal_page.grateful_2_text = grateful_field_2.text ?? "";
        journal_page.grateful_3_text = grateful_field_3.text ?? "";
        journal_page.focus_1_text = focus_field_1.text ?? "";
        journal_page.focus_2_text = focus_field_2.text ?? "";
        journal_page.day = current_date;
        
        Journal.add(journal_page);
        
        createUserMessage(message: "", title: "Page successfully added to journal", buttonText: "Okay")
    
    }
    
    
    @IBAction func pageTextFieldsEdited (sender: AnyObject) {
        
        // extract current page shown
        let journal_page = self.Journal.object(at: current_page_index_shown) as! JournalPage;
        
        // if the journal page shown has the current date => make edit possible
        if (journal_page.day == current_date) {
            
            switch (sender.tag) {
                case 0:
                    journal_page.let_go_text = let_go_field.text ?? ""; break;
                case 1:
                    journal_page.grateful_1_text = grateful_field_1.text ?? ""; break;
                case 2:
                    journal_page.grateful_2_text = grateful_field_2.text ?? ""; break;
                case 3:
                    journal_page.grateful_3_text = grateful_field_3.text ?? ""; break;
                case 4:
                    journal_page.focus_1_text = focus_field_1.text ?? ""; break;
                case 5:
                    journal_page.focus_2_text = focus_field_2.text ?? ""; break;
                default: break;
            }
            
            Journal.replaceObject(at: current_page_index_shown, with: journal_page);
            self.displayJournalPage();
        }
    }
    

    func createUserMessage(message: String, title: String, buttonText: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.default, handler: { _ in}));
        
        self.present(alert, animated: true, completion: nil);
        
    }
    

}

