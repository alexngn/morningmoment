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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backButtonClicked (sender: Any) {
        
        // ensure to not rerun viewDidLoad upon return to ViewController
        self.dismiss(animated: true, completion: self.delegate?.SettingsViewControllerDidBack);
        
    }
    
}
