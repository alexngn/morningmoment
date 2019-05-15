//
//  SettingsViewController.swift
//  MorningMoment
//
//  Created by Thea Birk Berger on 5/1/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsViewControllerDelegate: class {
    
    func SettingsViewControllerDidBack();
}


class SettingsViewController: UIViewController {
    
    // CLASS PROPERTIES
    weak var delegate: SettingsViewControllerDelegate?
    var journal_theme: Int!
    var JournalPageVC: JournalPageViewController!
    @IBOutlet weak var themePreviewImage: UIImageView!
    @IBOutlet weak var colorWheel: UIImageView!
    @IBOutlet weak var colorSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update local theme variable according to the current journal theme
        journal_theme = JournalPageVC.current_theme_ID
        
        // set slider properties
        colorSlider.minimumValue = 0;
        colorSlider.maximumValue = 5;
        colorSlider.value = Float(journal_theme ?? 2);
        colorSlider.makeVertical()
        updateThemePreview()
        
    }
    
    // slider pulled: change journal theme
    @IBAction func sliderPulled(_ sender: UISlider) {
        
        // change local journal theme according to slider value
        self.journal_theme = Int(sender.value)
        // set local JournalPageViewController object theme according to slider value
        JournalPageVC.theme_array[0].theme_ID = Int16(sender.value)
        // save local JournalPageViewController journal in CoreData
        PersistanceService.saveContext()
        // update theme preview image according to slider value
        updateThemePreview()
    }
    
    // set theme preview image according to local theme variable
    func updateThemePreview() {
        
        let image: UIImage!
        
        switch journal_theme {
            case 0: image = UIImage(named: "wheel_1")
                break;
            case 1: image = UIImage(named: "wheel_2")
                break;
            case 2: image = UIImage(named: "wheel_default")
                break;
            case 3: image = UIImage(named: "wheel_3")
                break;
            case 4: image = UIImage(named: "wheel_4")
                break;
            case 5: image = UIImage(named: "wheel_5")
                break;
            default: image = UIImage(named: "wheel_default")
                break;
        }
        themePreviewImage.image = image
    }
   
    // back button clicked: return to menu
    @IBAction func backButtonClicked (sender: Any) {
        
        // ensure to not rerun viewDidLoad upon return to menu
        self.dismiss(animated: true, completion: self.delegate?.SettingsViewControllerDidBack);
        
    }
    
}

// make slider vertical: rotate by PI/2
extension UIView {
    func makeVertical() {
        transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
}


