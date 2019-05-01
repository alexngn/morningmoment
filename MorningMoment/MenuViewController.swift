//
//  menuViewController.swift
//  MorningMoment
//
//  Created by Owner on 4/22/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController{
	var today_color = UIColor.init(red: 0, green: 0.9373, blue: 0.9373, alpha: 1);
    
    
    @IBOutlet weak var menuLabel: UILabel!
    
    override func viewDidLoad() {
		super.viewDidLoad()
		menuLabel.numberOfLines = 0
		menuLabel.text = "Morning\nMoment";
		self.view.backgroundColor = today_color
	}
    
    @IBAction func onCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
