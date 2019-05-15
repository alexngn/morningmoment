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
    var theme_array: [CDTheme]!
    var current_theme_ID: Int!
    var journal_color: UIColor = UIColor.init(red: 0.8, green: 0.930, blue: 0.904, alpha: 1);
    var today_color: UIColor = UIColor.init(red: 0.938, green: 0.822, blue: 0.882, alpha: 1);
    var current_page_index_shown = 0;
    var todays_date_string: String!
    var todays_date: NSDate!
    var current_segmentedControlIndex = 1;
    var previous_segmentedControl = 1;
    let dateFormatter = DateFormatter()
    
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
    @IBOutlet weak var background_gradient: UIImageView!
    
    // CLASS METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up CoreData: Create two arrays: [CoreData journal pages] and [CoreData theme]
        let fetchRequest: NSFetchRequest<CDJournalPage> = CDJournalPage.fetchRequest()
        let fetchRequest2: NSFetchRequest<CDTheme> = CDTheme.fetchRequest()
        
        do {
            let CDJournal = try PersistanceService.context.fetch(fetchRequest)
            self.CDJournal = CDJournal //as! NSMutableArray
            let theme_array = try PersistanceService.context.fetch(fetchRequest2)
            self.theme_array = theme_array
        } catch{}
        
        // set textfield tags
        self.let_go_field.tag = 0;
        self.grateful_field_1.tag = 1;
        self.grateful_field_2.tag = 2;
        self.grateful_field_3.tag = 3;
        self.focus_field_1.tag = 4;
        self.focus_field_2.tag = 5;
        
        // import today's date
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = Date();
        self.todays_date = date as NSDate
        self.todays_date_string = dateFormatter.string(from: date);
        
        // set slider properties
        moodSlider.minimumValue = 0;
        moodSlider.maximumValue = 8;
        
        // if TODAY's journal entry has already been made => set slider accordingly
        if (CDJournal.count > 0 && CDJournal.last?.date_string?.elementsEqual(todays_date_string) ?? false) {
            let journal_page = CDJournal.last
            moodSlider.value = Float(Int(journal_page!.mood))
        // otherwise place slider in center
        } else {
            moodSlider.value = 4.0
            showEmojiWithNumber(number: 4)
        }
        
        // if CoreData journal theme has not been initialized => set theme ID to default
        if (theme_array.count == 0) {
            let theme = CDTheme(context: PersistanceService.context)
            theme.theme_ID = 2
            theme_array.append(theme)
            current_theme_ID = 2
        } // otherwise set theme ID to CoreData theme
        else {
            current_theme_ID = Int(theme_array[0].theme_ID)
        }
        
        // update colors and pictures of the journal according to theme
        setJournalTheme()
        
        // uncomment to input 6 journal entries
        /*
        if (CDJournal.count == 0) {
            hardCodeJournalEntries(perform: true)
        }*/
        
        // set journal text field input limits
        self.limitTextFieldInputs()
        
        // set segmented control
        segmentedControl.selectedSegmentIndex = previous_segmentedControl
        performSegmentWithIndex(index: previous_segmentedControl)
        
    }
    
    // uncomment to remove theme from core data
    /*
    override func viewDidAppear(_ animated: Bool) {
        self.deleteAllData("CDTheme")
    }*/
    
    // uncomment to clear all journal entries from core data
    /*
    override func viewDidAppear(_ animated: Bool) {
        self.deleteAllData("CDJournalPage")
    }*/
    
    // display empty template journal page and enable editing
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
        large_date_label.text = todays_date_string;
        journal_empty_label.isHidden = true;
        journal_empty_label_2.isHidden = true;
        animatedArrow.isHidden = true;
        display_mood_emoji.isHidden = true;
        current_mood_label.isHidden = false;
    }
    
    // display TODAY's journal page and enable editing
    func displayTodaysPage () {
        
        current_page_index_shown = CDJournal.count - 1;
        
        let journal_page = CDJournal[current_page_index_shown]
        
        let_go_field.text = journal_page.let_go_text;
        grateful_field_1.text = journal_page.grateful_1_text;
        grateful_field_2.text = journal_page.grateful_2_text;
        grateful_field_3.text = journal_page.grateful_3_text;
        focus_field_1.text = journal_page.focus_1_text;
        focus_field_2.text = journal_page.focus_2_text;
        small_date_label.text = todays_date_string;
        large_date_label.text = todays_date_string;
        
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
    
    // display journal and disable editing
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
            small_date_label.text = journal_page.date_string;
            large_date_label.text = journal_page.date_string;
            
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
    
    // empty all journal text fields
    func clearTextFields () {
        
        let_go_field.text = "";
        grateful_field_1.text = "";
        grateful_field_2.text = "";
        grateful_field_3.text = "";
        focus_field_1.text = "";
        focus_field_2.text = "";
        
    }
    
    // enable editing for all journal text fields
    func enableTextFields (b: Bool) {
        
        let_go_field.isEnabled = b;
        grateful_field_1.isEnabled = b;
        grateful_field_2.isEnabled = b;
        grateful_field_3.isEnabled = b;
        focus_field_1.isEnabled = b;
        focus_field_2.isEnabled = b;
    }
    
    // submit button pushed: Add a new journal entry to journal
    @IBAction func submitButtonPushed (sender: Any) {
        
        // create new journal page
        let journal_page = CDJournalPage(context: PersistanceService.context)
        
        // add text field content to journal page properties
        journal_page.let_go_text = let_go_field.text ?? "";
        journal_page.grateful_1_text = grateful_field_1.text ?? "";
        journal_page.grateful_2_text = grateful_field_2.text ?? "";
        journal_page.grateful_3_text = grateful_field_3.text ?? "";
        journal_page.focus_1_text = focus_field_1.text ?? "";
        journal_page.focus_2_text = focus_field_2.text ?? "";
        journal_page.date_string = todays_date_string;
        journal_page.date = todays_date;
        journal_page.mood = Int16(moodSlider.value)
        
        // add journal page to journal
        CDJournal.append(journal_page);
        
        // update CoreData
        PersistanceService.saveContext()
        
        // display user message
        createUserMessage(message: "", title: "Page successfully added to journal", buttonText: "Okay")
        
        submit_button.isEnabled = false;
        submit_button.isHidden = true;
    }
    
    // text field edited: update TODAY's journal entry
    @IBAction func pageTextFieldsEdited (sender: AnyObject) {
        
        if (CDJournal.count != 0) {
            
            // extract newest journal entry
            let newest_journal_page = CDJournal[CDJournal.count - 1]
            
            // if the newest journal entry carries today's date (TODAY's journal entry has been submitted) => update it
            if (current_segmentedControlIndex == 1 && newest_journal_page.date_string == todays_date_string) {
                
                switch (sender.tag) {
                    
                case 0: newest_journal_page.let_go_text = let_go_field.text ?? ""; break;
                case 1: newest_journal_page.grateful_1_text = grateful_field_1.text ?? ""; break;
                case 2: newest_journal_page.grateful_2_text = grateful_field_2.text ?? ""; break;
                case 3: newest_journal_page.grateful_3_text = grateful_field_3.text ?? ""; break;
                case 4: newest_journal_page.focus_1_text = focus_field_1.text ?? ""; break;
                case 5: newest_journal_page.focus_2_text = focus_field_2.text ?? ""; break;
                default: break;
                    
                }
                // substitute the newest journal entry with its edited version
                CDJournal[CDJournal.count - 1] = newest_journal_page
                // save update in CoreData
                PersistanceService.saveContext()
            }
        }
    }
    
    // perform all setting involving a segmented control index change
    func performSegmentWithIndex (index: Int) {
        
        // update colors and pictures of the journal according to theme
        setJournalTheme()
        
        current_segmentedControlIndex = index
        
        // index selected: JOURNAL
        if (current_segmentedControlIndex == 0) {
            
            // if journal is empty => display empty journal page
            if (CDJournal.count == 0) {
                displayEmptyJournalPage(b: true);
            }
            // otherwise display newest journal entry
            else {
                current_page_index_shown = CDJournal.count - 1;
                displayJournal();
                enableTextFields(b: false);
            }
            // update previous_segmentedControl, that will be used when there is a return from menu
            previous_segmentedControl = current_segmentedControlIndex
        }
            
        // index selected: TODAY
        else if (current_segmentedControlIndex == 1) {
            
            // remove empty journal page visual features
            displayEmptyJournalPage(b: false);
            
            if (CDJournal.count != 0) {
                
                // extract newest journal entry
                let newest_journal_page = CDJournal[CDJournal.count - 1]
                
                // if TODAY's journal entry has been submitted => enable editing
                if (newest_journal_page.date_string == todays_date_string) {
                    
                    // display user message
                    if (previous_segmentedControl == 0) {
                        createUserMessage(message: "But you can edit your page until the end of the day", title: "You have already taken today's morning moment", buttonText: "Got it");
                    }
                    
                    displayTodaysPage();
                    enableTextFields(b: true);
                    submit_button.isEnabled = false;
                    submit_button.isHidden = true;
                }
                // otherwise display the empty journal page
                else {
                    displayTemplatePage();
                    enableTextFields(b: true);
                }
            }
           // otherwise display the empty journal page
            else {
                displayTemplatePage();
                enableTextFields(b: true);
            }
            // update previous_segmentedControl, that will be used when there is a return from menu
            previous_segmentedControl = current_segmentedControlIndex
        }
            
        // index selected: MENU
        else {
            // perform segue to menu
            performSegue(withIdentifier: "JournalToMenuSegue", sender:self)
        }
    }
    
    // segmented control index changed: perform settings
    @IBAction func segmentedControlValueChanged (sender: UISegmentedControl) {
        
        performSegmentWithIndex(index: sender.selectedSegmentIndex)
    }
    
    // right journal arrow pushed: show newer journal page
    @IBAction func rightArrowPushed (sender: UIButton) {
        
        // if the element requested is within array range
        if ((current_page_index_shown + 1) < CDJournal.count) {
            
            current_page_index_shown += 1;
            self.displayJournal();
            
            // update arrow appearance
            self.updateArrowAppearance();
            
        }
    }
    
    // left journal arrow pushed: show older journal page
    @IBAction func leftArrowPushed (sender: UIButton) {
        
        // if the element requested is within array range
        if ((current_page_index_shown - 1) >= 0) {
            current_page_index_shown -= 1;
            self.displayJournal();
            
            // update arrow appearance
            self.updateArrowAppearance();
            
        }
    }
    
    // update arrow arrearance according to journal page shown
    func updateArrowAppearance() {
        
        // if there is only one page in the journal
        if (CDJournal.count == 1) {
            right_arrow.isHidden = true;
            left_arrow.isHidden = true;
        }
        // if the page to be shown is at the journal head
        else if (current_page_index_shown == 0) {
            right_arrow.isHidden = false;
            left_arrow.isHidden = true;
        }
        // if the page to be shown is at the journal tail
        else if (current_page_index_shown == (CDJournal.count - 1)) {
            right_arrow.isHidden = true;
            left_arrow.isHidden = false;
        }
        // if the journal has 3 or more pages and the page to be shown is inside the journal
        else {
            right_arrow.isHidden = false;
            left_arrow.isHidden = false;
        }
        
    }
    
    // create user message with a title
    func createUserMessage(message: String, title: String, buttonText: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert);
        
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.default, handler: { _ in}));
        
        self.present(alert, animated: true, completion: nil);
    }
    
    // slider pulled: update emoji appearance
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
                
                // if TODAY's entry has already been made => update page mood
                if (newest_journal_page.date_string == todays_date_string) {
                    
                    newest_journal_page.mood = Int16(slider_value)
                    
                    // substitute the newest journal entry with its edited version
                    CDJournal[CDJournal.count - 1] = newest_journal_page
                    // update CoreData
                    PersistanceService.saveContext()
                }
            }
        }
    }
    
    // update journal theme colors and images
    func setJournalTheme() {
        
        var image = UIImage(named: "default_theme");
        var L_arrow_image = UIImage(named: "L_default");
        var R_arrow_image = UIImage(named: "R_default");
        
        let default_text_color = UIColor.init(red: 47/255.0, green: 113/255.0, blue: 118/255.0, alpha: 1);
        let theme1_color = UIColor.init(red: 0/255.0, green: 136/255.0, blue: 179/255.0, alpha: 1);
        let theme2_color = UIColor.init(red: 158/255.0, green: 81/255.0, blue: 0/255.0, alpha: 1);
        let theme3_color = UIColor.init(red: 128/255.0, green: 89/255.0, blue: 108/255.0, alpha: 1);
        let theme4_color = UIColor.init(red: 204/255.0, green: 103/255.0, blue: 10/255.0, alpha: 1);
        let theme5_color = UIColor.init(red: 125/255.0, green: 92/255.0, blue: 153/255.0, alpha: 1);
        
        // change journal theme according to current theme ID:
        // each of the 6 theme ID's corresponds to a group of journal text colors, submit-button and segmentedcontrol colors,
        // in addition to background and arrow images
        switch (current_theme_ID) {
            case 0: image = UIImage(named: "theme1");
                    L_arrow_image = UIImage(named: "L_theme0");
                    R_arrow_image = UIImage(named: "R_theme0");
                    setJournalThemeTextColor(color: theme1_color)
                    submit_button.backgroundColor = UIColor.init(red: 51/255.0, green: 207/255.0, blue: 255/255.0, alpha: 1);
                    segmentedControl.backgroundColor = UIColor.white
                    segmentedControl.tintColor = UIColor.init(red: 179/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 179/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 179/255.0, green: 98/255.0, blue: 18/255.0, alpha: 1);
                    break;
            case 1: image = UIImage(named: "theme2");
                    L_arrow_image = UIImage(named: "L_theme1");
                    R_arrow_image = UIImage(named: "R_theme1");
                    setJournalThemeTextColor(color: theme2_color)
                    submit_button.backgroundColor = UIColor.init(red: 89/255.0, green: 91/255.0, blue: 255/255.0, alpha: 1);
                    segmentedControl.backgroundColor = UIColor.white
                    segmentedControl.tintColor = UIColor.init(red: 89/255.0, green: 91/255.0, blue: 255/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 158/255.0, green: 144/255.0, blue: 0/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 158/255.0, green: 144/255.0, blue: 0/255.0, alpha: 1);
                    break;
            case 2: image = UIImage(named: "default_theme");
                    L_arrow_image = UIImage(named: "L_default");
                    R_arrow_image = UIImage(named: "R_default");
                    setJournalThemeTextColor(color: default_text_color)
                    submit_button.backgroundColor = UIColor.init(red: 100/255.0, green: 125/255.0, blue: 124/255.0, alpha: 1);
                    segmentedControl.backgroundColor = UIColor.white
                    segmentedControl.tintColor = UIColor.init(red: 136/255.0, green: 154/255.0, blue: 154/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 145/255.0, green: 129/255.0, blue: 137/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 145/255.0, green: 129/255.0, blue: 137/255.0, alpha: 1);
                    break;
            case 3: image =
                    UIImage(named: "theme3");
                    L_arrow_image = UIImage(named: "L_theme3");
                    R_arrow_image = UIImage(named: "R_theme3");
                    setJournalThemeTextColor(color: theme3_color)
                    submit_button.backgroundColor = UIColor.init(red: 161/255.0, green: 204/255.0, blue: 61/255.0, alpha: 1);
                    segmentedControl.backgroundColor = UIColor.white
                    segmentedControl.tintColor = UIColor.init(red: 204/255.0, green: 82/255.0, blue: 143/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 204/255.0, green: 82/255.0, blue: 143/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 204/255.0, green: 82/255.0, blue: 143/255.0, alpha: 1);
                    break;
            case 4: image =
                    UIImage(named: "theme4");
                    L_arrow_image = UIImage(named: "L_theme4");
                    R_arrow_image = UIImage(named: "R_theme4");
                    setJournalThemeTextColor(color: theme4_color)
                    submit_button.backgroundColor = UIColor.init(red: 204/255.0, green: 85/255.0, blue: 5/255.0, alpha: 1);
                    segmentedControl.tintColor = UIColor.init(red: 204/255.0, green: 85/255.0, blue: 5/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 204/255.0, green: 149/255.0, blue: 10/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 204/255.0, green: 149/255.0, blue: 10/255.0, alpha: 1);
                    break;
            case 5: image =
                    UIImage(named: "theme5");
                    L_arrow_image = UIImage(named: "L_theme3");
                    R_arrow_image = UIImage(named: "R_theme3");
                    setJournalThemeTextColor(color: theme5_color)
                    submit_button.backgroundColor = UIColor.init(red: 204/255.0, green: 134/255.0, blue: 20/255.0, alpha: 1);
                    segmentedControl.tintColor = UIColor.init(red: 121/255.0, green: 20/255.0, blue: 204/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 121/255.0, green: 20/255.0, blue: 204/255.0, alpha: 1);
                    large_date_label.textColor = UIColor.init(red: 121/255.0, green: 20/255.0, blue: 204/255.0, alpha: 1);
                    break;
        default: break;
        }
        background_gradient.image = image
        left_arrow.setImage(L_arrow_image, for: UIControl.State.normal)
        right_arrow.setImage(R_arrow_image, for: UIControl.State.normal)
    }
    
    // set journal text and bullet colors
    func setJournalThemeTextColor(color: UIColor) {
        let_go_label.textColor = color
        grateful_label.textColor = color
        focus_label.textColor = color
        bul11_label.textColor = color
        bul12_label.textColor = color
        bul13_label.textColor = color
        bul21_label.textColor = color
        bul22_label.textColor = color
        current_mood_label.textColor = color
    }
    
    // input 6 hardcoded journal pages to journal
    func hardCodeJournalEntries (perform: Bool) {
        
        let journal_page_1 = CDJournalPage(context: PersistanceService.context)
        
        journal_page_1.let_go_text = "What Kevin said to me yesterday about capitalism";
        journal_page_1.grateful_1_text = "The sun";
        journal_page_1.grateful_2_text = "Walking";
        journal_page_1.grateful_3_text = "Blossoming trees";
        journal_page_1.focus_1_text = "Believing in myself";
        journal_page_1.focus_2_text = "Finishing math assignment 8";
        journal_page_1.date_string = "03/04/2019";
        journal_page_1.date = dateFormatter.date(from: "03/04/2019") as NSDate?
        journal_page_1.mood = Int16(3)
        
        CDJournal.append(journal_page_1);
        // update core data
        if (perform) {
            PersistanceService.saveContext()
        }
        
        let journal_page_2 = CDJournalPage(context: PersistanceService.context)
        
        journal_page_2.let_go_text = "My diet";
        journal_page_2.grateful_1_text = "Parties on Thompson Street";
        journal_page_2.grateful_2_text = "Mary and Jen";
        journal_page_2.grateful_3_text = "The Joe Rogan Experience";
        journal_page_2.focus_1_text = "Enjoying cheesecake";
        journal_page_2.focus_2_text = "Breathing";
        journal_page_2.date_string = "03/05/2019";
        journal_page_2.date = dateFormatter.date(from: "03/05/2019") as NSDate?
        journal_page_2.mood = Int16(7)
        
        CDJournal.append(journal_page_2);
        // update core data
        if (perform) {
            PersistanceService.saveContext()
        }
        
        let journal_page_3 = CDJournalPage(context: PersistanceService.context)
        
        journal_page_3.let_go_text = "My roomate's mess";
        journal_page_3.grateful_1_text = "That time she made me a brownie";
        journal_page_3.grateful_2_text = "The floor being visible still";
        journal_page_3.grateful_3_text = "The man who sang \"Ain't no sunshine\" on the subway last night";
        journal_page_3.focus_1_text = "Letting the mess go";
        journal_page_3.focus_2_text = "Appreciate her person";
        journal_page_3.date_string = "03/06/2019";
        journal_page_3.date = dateFormatter.date(from: "03/06/2019") as NSDate?
        journal_page_3.mood = Int16(4)
        
        CDJournal.append(journal_page_3);
        // update core data
        if (perform) {
            PersistanceService.saveContext()
        }
        
        let journal_page_4 = CDJournalPage(context: PersistanceService.context)
        
        journal_page_4.let_go_text = "Not being recruited by the NBA";
        journal_page_4.grateful_1_text = "Ma gals";
        journal_page_4.grateful_2_text = "Marjane Satrapi";
        journal_page_4.grateful_3_text = "Long walks in nyc rain";
        journal_page_4.focus_1_text = "Reading more";
        journal_page_4.focus_2_text = "Spending quality time with Spencer";
        journal_page_4.date_string = "05/07/2019";
        journal_page_4.date = dateFormatter.date(from: "05/07/2019") as NSDate?
        journal_page_4.mood = Int16(4)
        
        CDJournal.append(journal_page_4);
        // update core data
        if (perform) {
            PersistanceService.saveContext()
        }
        
        let journal_page_5 = CDJournalPage(context: PersistanceService.context)
        
        journal_page_5.let_go_text = "The lost cookie recipe";
        journal_page_5.grateful_1_text = "The smell of beach";
        journal_page_5.grateful_2_text = "Deep convo with Dave today";
        journal_page_5.grateful_3_text = "My bed";
        journal_page_5.focus_1_text = "Meditating";
        journal_page_5.focus_2_text = "Sleeping";
        journal_page_5.date_string = "05/08/2019";
        journal_page_5.date = dateFormatter.date(from: "05/08/2019") as NSDate?
        journal_page_5.mood = Int16(2)
        
        CDJournal.append(journal_page_5);
        // update core data
        if (perform) {
            PersistanceService.saveContext()
        }
        
        let journal_page_6 = CDJournalPage(context: PersistanceService.context)
        
        journal_page_6.let_go_text = "This string constitutes the longest possible text field input";
        journal_page_6.grateful_1_text = "This string constitutes the longest possible text field input";
        journal_page_6.grateful_2_text = "This string constitutes the longest possible text field input";
        journal_page_6.grateful_3_text = "This string constitutes the longest possible text field input";
        journal_page_6.focus_1_text = "This string constitutes the longest possible text field input";
        journal_page_6.focus_2_text = "This string constitutes the longest possible text field input";
        journal_page_6.date_string = "05/14/2019";
        journal_page_6.date = dateFormatter.date(from: "05/14/2019") as NSDate?
        journal_page_6.mood = Int16(8)
        
        CDJournal.append(journal_page_6);
        // update core data
        if (perform) {
            PersistanceService.saveContext()
        }
        
    }
    
    // display one mood slider emoji image
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
    
    // hide all mood slider emoji images
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
    
    // display the submitted emoji in journal
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
    
    // display empty journal page: disable almost all journal content
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
    
    // apply text field character limitation to all journal text fields
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
    
    // set local menu object "JournalPageVC" to this JournalPageViewController upon segue performance,
    // transferring all data to the menu
    public override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        
        let menuVC = segue.destination as! MenuViewController
        menuVC.JournalPageVC = self
        
    }
    
    // delete everything saved in CoreDate
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
    
    // set journal text field input limitations to 61 characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 61
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // extract journal from CoreData
        let fetchRequest: NSFetchRequest<CDJournalPage> = CDJournalPage.fetchRequest()
        
        // update the local journal object with the CoreData journal
        do {
            let CDJournal = try PersistanceService.context.fetch(fetchRequest)
            self.CDJournal = CDJournal
        } catch{}
        
        // perform viewDidLoad to ensure that all updates of the journal made from the menu is updated locally
        self.viewDidLoad()
    }
    
}





