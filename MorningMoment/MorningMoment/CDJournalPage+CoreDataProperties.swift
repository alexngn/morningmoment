//
//  CDJournalPage+CoreDataProperties.swift
//  MorningMoment
//
//  Created by Thea Birk Berger on 4/29/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//
//

import Foundation
import CoreData


extension CDJournalPage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDJournalPage> {
        return NSFetchRequest<CDJournalPage>(entityName: "CDJournalPage")
    }

    @NSManaged public var let_go_text: String?
    @NSManaged public var grateful_1_text: String?
    @NSManaged public var grateful_2_text: String?
    @NSManaged public var grateful_3_text: String?
    @NSManaged public var focus_1_text: String?
    @NSManaged public var focus_2_text: String?
    @NSManaged public var day: String?

}
