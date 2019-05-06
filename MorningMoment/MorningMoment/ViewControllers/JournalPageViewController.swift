//
//  ViewController.swift
//  MorningMoment
//
//  Created by Thea Birk Berger on 4/10/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit
import CoreData

class JournalPageViewController: UIViewController, UITextFieldDelegate {
    
    // CLASS PROPERTIES
    var CDJournal: [CDJournalPage]!
    var journal_color: UIColor = UIColor.init(red: 0.8, green: 0.930, blue: 0.904, alpha: 1);
    var current_page_index_shown = 0;
    var todays_date: String!
    var current_segmentedControlIndex = 1;
    var previous_segmentedControl = 1;
    
    // labels
    @IBOutlet weak var let_go_label: UILabel!
    @IBOutlet weak var grateful_label: UILabel!
    @IBOutlet weak var focus_label: UILabel!
    @IBOutlet weak var bul11_label: UILabel!
    @IBOutlet weak var bul12_label: UILabel!
    @IBOutlet weak var bul13_label: UILabel!
    @IBOutlet weak var bul21_label: UILabel!
    @IBOutlet weak var bul22_label: UILabel!
    @IBOutlet weak var small_date_label: UILabel!
    
    @IBOutlet weak var large_date_label: UILabel!
    @IBOutlet weak var journal_empty_label: UILabel!
    @IBOutlet weak var journal_empty_label_2: UILabel!
    @IBOutlet weak var current_mood_label: UILabel!
    
    // textfields
    @IBOutlet weak var let_go_field: UITextField!
    @IBOutlet weak var grateful_field_1: UITextField!
    @IBOutlet weak var grateful_field_2: UITextField!
    @IBOutlet weak var grateful_field_3: UITextField!
    @IBOutlet weak var focus_field_1: UITextField!
    @IBOutlet weak var focus_field_2: UITextField!
    
    // buttons
    @IBOutlet weak var left_arrow: UIButton!
    @IBOutlet weak var right_arrow: UIButton!
    @IBOutlet weak var submit_button: UIButton!
    
    // segmented controller, slider
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var moodSlider: UISlider!
    
    // images
    @IBOutlet weak var animatedArrow: UIImageView!
    @IBOutlet weak var emoji_0: UIImageView!
    @IBOutlet weak var emoji_1: UIImageView!
    @IBOutlet weak var emoji_2: UIImageView!
    @IBOutlet weak var emoji_3: UIImageView!
    @IBOutlet weak var emoji_4: UIImageView!
    @IBOutlet weak var emoji_5: UIImageView!
    @IBOutlet weak var emoji_6: UIImageView!
    @IBOutlet weak var emoji_7: UIImageView!
    @IBOutlet weak var emoji_8: UIImageView!
    @IBOutlet weak var display_mood_emoji: UIImageView!
    
    
    // CLASS METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up CoreData: Create array of CoreData journal pages
        let fetchRequest: NSFetchRequest<CDJournalPage> = CDJournalPage.fetchRequest()
        
        do {
            let CDJournal = try PersistanceService.context.fetch(fetchRequest)
            self.CDJournal = CDJournal //as! NSMutableArray
        } catch{}
        
        // set textfield tags
        self.let_go_field.tag = 0;
        self.grateful_field_1.tag = 1;
        self.grateful_field_2.tag = 2;
        self.grateful_field_3.tag = 3;
        self.focus_field_1.tag = 4;
        self.focus_field_2.tag = 5;
        
        // update date
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.todays_date = dateFormatter.string(from: date);
        
        // set initial segmented control
        segmentedControl.selectedSegmentIndex = 1;
        performSegmentWithIndex(index: 1)
        //self.segmentedControlValueChanged(sender: segmentedControl);
        
        // set slider properties
        moodSlider.minimumValue = 0;
        moodSlider.maximumValue = 8;
        // if TODAY's journal entry has been made
        if (CDJournal.count > 0 && CDJournal.last?.day?.elementsEqual(todays_date) ?? false) {
            let journal_page = CDJournal.last
            moodSlider.value = Float(Int(journal_page!.mood))
        // otherwise place slider in center
        } else {
            moodSlider.value = 4.0
            showEmojiWithNumber(number: 4)
        }
        
        self.limitTextFieldInputs()
    }
    
    
    /*
     // clear CoreData
     override func viewDidAppear(_ animated: Bool) {
     self.deleteAllData("CDJournalPage")
     }*/
    
    // TODAY's journal entry has not yet been made
    func displayTemplatePage () {
        
        self.hideEmojis()
        moodSlider.isHidden = false;
        moodSlider.value = 4.0
        showEmojiWithNumber(number: 4)
        clearTextFields();
        enableTextFields(b: true);
        submit_button.isHidden = false;
        submit_button.isEnabled = true;
        left_arrow.isHidden = true;
        left_arrow.isEnabled = false;
        right_arrow.isHidden = true;
        right_arrow.isEnabled = false;
        small_date_label.isHidden = true;
        large_date_label.isHidden = false;
        large_date_label.text = todays_date;
        journal_empty_label.isHidden = true;
        journal_empty_label_2.isHidden = true;
        animatedArrow.isHidden = true;
        display_mood_emoji.isHidden = true;
        current_mood_label.isHidden = false;
    }
    
    // TODAY's journal entry has been made
    func displayTodaysPage () {
        
        current_page_index_shown = CDJournal.count - 1;
        
        let journal_page = CDJournal[current_page_index_shown]
        
        let_go_field.text = journal_page.let_go_text;
        grateful_field_1.text = journal_page.grateful_1_text;
        grateful_field_2.text = journal_page.grateful_2_text;
        grateful_field_3.text = journal_page.grateful_3_text;
        focus_field_1.text = journal_page.focus_1_text;
        focus_field_2.text = journal_page.focus_2_text;
        small_date_label.text = todays_date;
        large_date_label.text = todays_date;
        
        submit_button.isHidden = false;
        submit_button.isEnabled = true;
        left_arrow.isHidden = true;
        left_arrow.isEnabled = false;
        right_arrow.isHidden = true;
        right_arrow.isEnabled = false;
        small_date_label.isHidden = true;
        large_date_label.isHidden = false;
        journal_empty_label.isHidden = true;
        journal_empty_label_2.isHidden = true;
        animatedArrow.isHidden = true;
        
        self.hideEmojis()
        moodSlider.isHidden = false;
        moodSlider.value = Float(journal_page.mood)
        display_mood_emoji.isHidden = true;
        self.showEmojiWithNumber(number: Int(journal_page.mood))
        
    }
    
    func displayJournal () {
        
        animatedArrow.isHidden = true;
        self.hideEmojis()
        moodSlider.isHidden = true;
        
        if (CDJournal.count == 0) {
            self.displayEmptyJournalPage(b: true);
        }
            
        else {
            
            // extract current page shown
            let journal_page = CDJournal[current_page_index_shown]
            
            let_go_field.text = journal_page.let_go_text;
            grateful_field_1.text = journal_page.grateful_1_text;
            grateful_field_2.text = journal_page.grateful_2_text;
            grateful_field_3.text = journal_page.grateful_3_text;
            focus_field_1.text = journal_page.focus_1_text;
            focus_field_2.text = journal_page.focus_2_text;
            small_date_label.text = journal_page.day;
            large_date_label.text = journal_page.day;
            
            submit_button.isHidden = true;
            submit_button.isEnabled = false;
            left_arrow.isHidden = false;
            left_arrow.isEnabled = true;
            right_arrow.isHidden = false;
            right_arrow.isEnabled = true;
            small_date_label.isHidden = false;
            large_date_label.isHidden = true;
            journal_empty_label.isHidden = true;
            journal_empty_label_2.isHidden = true;
            display_mood_emoji.isHidden = false;
            current_mood_label.isHidden = false;
            
            updateArrowAppearance();
            displayMoodEmojiWithNumber(number: Int(journal_page.mood))
        }
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
        
        let journal_page = CDJournalPage(context: PersistanceService.context)
        
        journal_page.let_go_text = let_go_field.text ?? "";
        journal_page.grateful_1_text = grateful_field_1.text ?? "";
        journal_page.grateful_2_text = grateful_field_2.text ?? "";
        journal_page.grateful_3_text = grateful_field_3.text ?? "";
        journal_page.focus_1_text = focus_field_1.text ?? "";
        journal_page.focus_2_text = focus_field_2.text ?? "";
        journal_page.day = todays_date;
        journal_page.mood = Int16(moodSlider.value)
        
        CDJournal.append(journal_page);
        
        PersistanceService.saveContext()
        
        createUserMessage(message: "", title: "Page successfully added to journal", buttonText: "Okay")
        
        submit_button.isEnabled = false;
        submit_button.isHidden = true;
    }
    
    
    
    @IBAction func pageTextFieldsEdited (sender: AnyObject) {
        
        if (CDJournal.count != 0) {
            
            // extract newest journal entry
            let newest_journal_page = CDJournal[CDJournal.count - 1]
            
            // if "TODAY" has been pushed and today's entry has already been made
            if (current_segmentedControlIndex == 1 && newest_journal_page.day == todays_date) {
                
                switch (sender.tag) {
                    
                case 0:
                    newest_journal_page.let_go_text = let_go_field.text ?? ""; break;
                case 1:
                    newest_journal_page.grateful_1_text = grateful_field_1.text ?? ""; break;
                case 2:
                    newest_journal_page.grateful_2_text = grateful_field_2.text ?? ""; break;
                case 3:
                    newest_journal_page.grateful_3_text = grateful_field_3.text ?? ""; break;
                case 4:
                    newest_journal_page.focus_1_text = focus_field_1.text ?? ""; break;
                case 5:
                    newest_journal_page.focus_2_text = focus_field_2.text ?? ""; break;
                default: break;
                    
                }
                // update today's entry
                CDJournal[CDJournal.count - 1] = newest_journal_page
                
                PersistanceService.saveContext()
            }
        }
    }
    
    func performSegmentWithIndex (index: Int) {
        
        current_segmentedControlIndex = index
        
        // JOURNAL
        if (current_segmentedControlIndex == 0) {
            
            if (CDJournal.count == 0) {
                displayEmptyJournalPage(b: true);
            }
            else {
                current_page_index_shown = CDJournal.count - 1;
                displayJournal();
                enableTextFields(b: false);
            }
            previous_segmentedControl = current_segmentedControlIndex
        }
            
            // TODAY
        else if (current_segmentedControlIndex == 1) {
            
            displayEmptyJournalPage(b: false);
            
            // if today's entry have been submitted => enable editing
            if (CDJournal.count != 0) {
                
                // extract newest journal entry
                let newest_journal_page = CDJournal[CDJournal.count - 1]
                
                if (newest_journal_page.day == todays_date) {
                    
                    createUserMessage(message: "You can edit your page until the end of the day", title: "You have already taken today's morning moment", buttonText: "Got it");
                    
                    displayTodaysPage();
                    enableTextFields(b: true);
                    submit_button.isEnabled = false;
                    submit_button.isHidden = true;
                }
                    
                else {
                    displayTemplatePage();
                    enableTextFields(b: true);
                }
            }
                // otherwise enable template
            else {
                displayTemplatePage();
                enableTextFields(b: true);
            }
            previous_segmentedControl = current_segmentedControlIndex
        }
            
            // MENU
        else {
            
            performSegue(withIdentifier: "JournalToMenuSegue", sender:self)
            
            segmentedControl.selectedSegmentIndex = previous_segmentedControl
            performSegmentWithIndex(index: previous_segmentedControl)
            
        }
    }
    
    
    @IBAction func segmentedControlValueChanged (sender: UISegmentedControl) {
        
        performSegmentWithIndex(index: sender.selectedSegmentIndex)
    }
    
    // Right arrow clicked action method
    @IBAction func rightArrowPushed (sender: UIButton) {
        
        // if the element requested is within array range
        if ((current_page_index_shown + 1) < CDJournal.count) {
            
            current_page_index_shown += 1;
            self.displayJournal();
            
            // update arrow appearance
            self.updateArrowAppearance();
            
        }
    }
    
    // Left arrow clicked action method
    @IBAction func leftArrowPushed (sender: UIButton) {
        
        // if the element requested is within array range
        if ((current_page_index_shown - 1) >= 0) {
            current_page_index_shown -= 1;
            self.displayJournal();
            
            // update arrow appearance
            self.updateArrowAppearance();
            
        }
    }
    
    func updateArrowAppearance() {
        
        // if there is only one student in the gradebook
        if (CDJournal.count == 1) {
            right_arrow.isHidden = true;
            left_arrow.isHidden = true;
        }
            // if the student to be shown is at the gradebook head
        else if (current_page_index_shown == 0) {
            right_arrow.isHidden = false;
            left_arrow.isHidden = true;
        }
            // if the student to be shown is at the gradebook tail
        else if (current_page_index_shown == (CDJournal.count - 1)) {
            right_arrow.isHidden = true;
            left_arrow.isHidden = false;
        }
            // if the gradebook has 3 or more students and the student to be shown is inside the gradebook
        else {
            right_arrow.isHidden = false;
            left_arrow.isHidden = false;
        }
        
    }
    
    
    
    
    func createUserMessage(message: String, title: String, buttonText: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.default, handler: { _ in}));
        
        self.present(alert, animated: true, completion: nil);
        
    }
    
    @IBAction func sliderPulled(_ sender: UISlider) {
    
        if (current_segmentedControlIndex == 1) {
            
            let slider_value = Int(sender.value)
            
            // show emojis according to slider position
            self.hideEmojis()
            self.showEmojiWithNumber(number: slider_value)
            
            // update mood for TODAY's journal entry if applicable
            if (CDJournal.count != 0) {
                
                // extract newest journal entry
                let newest_journal_page = CDJournal[CDJournal.count - 1]
                
                // if "TODAY" has been pushed and today's entry has already been made => update page mood
                if (newest_journal_page.day == todays_date) {
                    
                    newest_journal_page.mood = Int16(slider_value)
                    
                    // update today's entry
                    CDJournal[CDJournal.count - 1] = newest_journal_page
                    
                    PersistanceService.saveContext()
                }
            }
        }
    }
    
    
    func hardCodeJournalEntries () {
        
        let journal_page_1 = CDJournalPage(context: PersistanceService.context)
        
        journal_page_1.let_go_text = "What Kevin said to me yesterday about capitalism";
        journal_page_1.grateful_1_text = "The sun";
        journal_page_1.grateful_2_text = "Walking";
        journal_page_1.grateful_3_text = "Blossoming trees";
        journal_page_1.focus_1_text = "Believing in myself";
        journal_page_1.focus_2_text = "Finishing math assignment 8";
        journal_page_1.day = "04/5/2019";
        
        CDJournal.append(journal_page_1);
        
        let journal_page_2 = CDJournalPage(context: PersistanceService.context)
        
        journal_page_2.let_go_text = "My diet";
        journal_page_2.grateful_1_text = "Parties on Thompson Street";
        journal_page_2.grateful_2_text = "Mary and Jen";
        journal_page_2.grateful_3_text = "The Joe Rogan Experience";
        journal_page_2.focus_1_text = "Enjoying cheesecake";
        journal_page_2.focus_2_text = "Breathing";
        journal_page_2.day = "04/10/2019";
        
        CDJournal.append(journal_page_2);
        
        let journal_page_3 = CDJournalPage(context: PersistanceService.context)
        
        journal_page_3.let_go_text = "My roomate's mess";
        journal_page_3.grateful_1_text = "That time she made me a brownie";
        journal_page_3.grateful_2_text = "The floor being visible still";
        journal_page_3.grateful_3_text = "The man who sang \"Ain't no sunshine\" on the subway last night";
        journal_page_3.focus_1_text = "Letting the mess go";
        journal_page_3.focus_2_text = "Appreciate her person";
        journal_page_3.day = "04/11/2019";
        
        CDJournal.append(journal_page_3);
        
        //PersistanceService.saveContext()
        
    }
    
    func showEmojiWithNumber(number: Int) {
        
        switch (number) {
        case 0: emoji_0.isHidden = false; break;
        case 1: emoji_1.isHidden = false; break;
        case 2: emoji_2.isHidden = false; break;
        case 3: emoji_3.isHidden = false; break;
        case 4: emoji_4.isHidden = false; break;
        case 5: emoji_5.isHidden = false; break;
        case 6: emoji_6.isHidden = false; break;
        case 7: emoji_7.isHidden = false; break;
        case 8: emoji_8.isHidden = false; break;
        default: break;
        }
    }
    
    
    func hideEmojis() {
        emoji_0.isHidden = true;
        emoji_1.isHidden = true;
        emoji_2.isHidden = true;
        emoji_3.isHidden = true;
        emoji_4.isHidden = true;
        emoji_5.isHidden = true;
        emoji_6.isHidden = true;
        emoji_7.isHidden = true;
        emoji_8.isHidden = true;
    }
    
    func displayMoodEmojiWithNumber(number: Int) {
        
        var image = UIImage(named: "0_emoji");
        
        switch (number) {
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
        
        self.display_mood_emoji.image = image;
    }
    
    
    func displayEmptyJournalPage (b: Bool) {
        
        // show animated arrow
        animatedArrow.isHidden = false;
        
        UIView.animate(withDuration: 0.5, animations: { self.animatedArrow.frame.origin.y -= 20}) {_ in UIView.animateKeyframes(withDuration: 0.5, delay: 0.25, options: [.autoreverse, .repeat], animations: {self.animatedArrow.frame.origin.y += 20})
        }
        
        journal_empty_label.isHidden = !b;
        journal_empty_label.isEnabled = b;
        journal_empty_label_2.isHidden = !b;
        journal_empty_label_2.isEnabled = b;
        
        submit_button.isHidden = b;
        submit_button.isEnabled = !b;
        left_arrow.isHidden = b;
        left_arrow.isEnabled = !b;
        right_arrow.isHidden = b;
        right_arrow.isEnabled = !b;
        small_date_label.isHidden = b;
        large_date_label.isHidden = b;
        
        let_go_field.isHidden = b;
        let_go_field.isEnabled = !b;
        grateful_field_1.isHidden = b;
        grateful_field_1.isEnabled = !b;
        grateful_field_2.isHidden = b;
        grateful_field_2.isEnabled = !b;
        grateful_field_3.isHidden = b;
        grateful_field_3.isEnabled = !b;
        focus_field_1.isHidden = b;
        focus_field_1.isEnabled = !b;
        focus_field_2.isHidden = b;
        focus_field_2.isEnabled = !b;
        
        let_go_label.isHidden = b;
        grateful_label.isHidden = b;
        bul11_label.isHidden = b;
        bul12_label.isHidden = b;
        bul13_label.isHidden = b;
        focus_label.isHidden = b;
        bul21_label.isHidden = b;
        bul22_label.isHidden = b;
        current_mood_label.isHidden = b;
        
        self.hideEmojis()
        moodSlider.isHidden = b;
        display_mood_emoji.isHidden = b;
    }
    
    func limitTextFieldInputs() {
        let_go_field.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        let_go_field.delegate = self
        grateful_field_1.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        grateful_field_1.delegate = self
        grateful_field_2.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        grateful_field_2.delegate = self
        grateful_field_3.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        grateful_field_3.delegate = self
        focus_field_1.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        focus_field_1.delegate = self
        focus_field_2.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        focus_field_2.delegate = self
    }
    
    func deleteAllData(_ entity:String) {
        
        let managedContext =  PersistanceService.context.persistentStoreCoordinator
        let context = PersistanceService.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext?.execute(batchDeleteRequest, with: context)
        }
        catch {
            print(error)
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 61
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        
        let destination = segue.destination as? MenuViewController
        
        destination?.CDJournal = self.CDJournal
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<CDJournalPage> = CDJournalPage.fetchRequest()
        
        do {
            let CDJournal = try PersistanceService.context.fetch(fetchRequest)
            self.CDJournal = CDJournal //as! NSMutableArray
        } catch{}
    }
    
}





