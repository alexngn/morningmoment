//
//  DeletePagesViewController.swift
//  MorningMoment
//
//  Created by Thea Birk Berger on 5/1/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol DeleteViewControllerDelegate: class {
    
    func DeleteViewControllerDidBack();
}


class DeleteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
	
    // CLASS PROPERTIES
	@IBOutlet weak var table: UITableView!
    weak var delegate: DeleteViewControllerDelegate?
	var CDJournal : [CDJournalPage]!
    
	override func viewDidLoad() {
        super.viewDidLoad()
		table.dataSource = self
		table.delegate = self
		table.isEditing = true;
		let fetchRequest: NSFetchRequest<CDJournalPage> = CDJournalPage.fetchRequest()
		
		do {
			let CDJournal = try PersistanceService.context.fetch(fetchRequest)
			self.CDJournal = CDJournal //as! NSMutableArray
		} catch{}
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return CDJournal.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
		cell.textLabel?.text = CDJournal[indexPath.row].day
		return cell
	}
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		table.setEditing(editing, animated: animated)
	}
    
    /*
    // change default delete label color
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete_label = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in }
        delete_label.backgroundColor = UIColor.init(red: 179/255.0, green: 155/255.0, blue: 169/255.0, alpha: 1);
        return [delete_label]
    }*/
    
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		let Page: CDJournalPage = CDJournal[indexPath.row]
		CDJournal.remove(at: indexPath.row)
		table.beginUpdates()
		table.deleteRows(at: [indexPath], with: .automatic)

        // update core data
		PersistanceService.context.delete(Page)
		PersistanceService.saveContext()
		tableView.endUpdates()
	}
	
    @IBAction func backButtonClicked (sender: Any) {
        // ensure to not rerun viewDidLoad upon return to ViewController
        self.dismiss(animated: true, completion: self.delegate?.DeleteViewControllerDidBack);
    }

}
