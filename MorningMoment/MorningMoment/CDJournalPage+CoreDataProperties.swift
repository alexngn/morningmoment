//
//  CDJournalPage+CoreDataProperties.swift
//  Created by Thea Birk Berger on 5/6/19.
//
//

import Foundation
import CoreData


extension CDJournalPage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDJournalPage> {
        return NSFetchRequest<CDJournalPage>(entityName: "CDJournalPage")
    }

    @NSManaged public var date_string: String?
    @NSManaged public var focus_1_text: String?
    @NSManaged public var focus_2_text: String?
    @NSManaged public var grateful_1_text: String?
    @NSManaged public var grateful_2_text: String?
    @NSManaged public var grateful_3_text: String?
    @NSManaged public var let_go_text: String?
    @NSManaged public var mood: Int16
    @NSManaged public var date: NSDate?

}
