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
    

    @IBOutlet weak var selectedThemeView: UIImageView!
    @IBOutlet weak var colorWheel: UIImageView!
    @IBOutlet weak var colorSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set slider properties
        colorSlider.minimumValue = 0;
        colorSlider.maximumValue = 5;
        colorSlider.value = Float(journal_theme);
        colorSlider.makeVertical()
        updateThemeView()
        
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        self.journal_theme = Int(sender.value)
        JournalPageVC.journal_theme = self.journal_theme;
        updateThemeView()
    }
    
    func updateThemeView() {
        
        let image: UIImage!
        
        switch journal_theme {
            case 0:
                image = UIImage(named: "wheel_1")
                break;
            case 1:
                image = UIImage(named: "wheel_2")
                break;
            case 2:
                image = UIImage(named: "wheel_default")
                break;
            case 3:
                image = UIImage(named: "wheel_3")
                break;
            case 4:
                image = UIImage(named: "wheel_4")
                break;
            case 5:
                image = UIImage(named: "wheel_5")
                break;
            default:
                image = UIImage(named: "wheel_default")
                break;
        }
        selectedThemeView.image = image
        
    }
   
    
    @IBAction func backButtonClicked (sender: Any) {
        
        // ensure to not rerun viewDidLoad upon return to ViewController
        self.dismiss(animated: true, completion: self.delegate?.SettingsViewControllerDidBack);
        
    }
    
}

extension UIView
{
    func makeVertical()
    {
        transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
}


