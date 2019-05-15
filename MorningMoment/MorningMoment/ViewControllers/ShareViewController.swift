//
//  ShareViewController.swift
//  MorningMoment
//
//  Created by Alex Nguyen on 5/1/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import Foundation
import UIKit
import CoreData
protocol ShareViewControllerDelegate: class {
    
    func ShareViewControllerDidBack();
}


class ShareViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // CLASS PROPERTIES
    @IBOutlet weak var table: UITableView!
    weak var delegate: ShareViewControllerDelegate?
    var JournalPageController: JournalPageViewController!
    var CDJournal : [CDJournalPage]!
    var selectedRow: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest: NSFetchRequest<CDJournalPage> = CDJournalPage.fetchRequest()
        
        do {
            let CDJournal = try PersistanceService.context.fetch(fetchRequest)
            self.CDJournal = CDJournal //as! NSMutableArray
        } catch{}
        
        table.dataSource = self
        table.delegate = self

    }
    
    // do any additional setup after loading the view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CDJournal.count;
    }
    
    // label rows with the date of journal pages
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = CDJournal[indexPath.row].date_string
        return cell
    }
    
    // perform segue on selected table cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SharePageSegue", sender: nil)
    }
    
    // back button clicked: return to menu
    @IBAction func backButtonClicked (sender: Any) {
        
        self.dismiss(animated: true, completion: self.delegate?.ShareViewControllerDidBack);
    }
    
    //Prepare to load page by sending selected journal page data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let SharePageVC:SharePageViewController = segue.destination as! SharePageViewController
        selectedRow = table.indexPathForSelectedRow!.row
        SharePageVC.ShareVC = self
        SharePageVC.setPage(p: CDJournal[selectedRow])
    }
}




