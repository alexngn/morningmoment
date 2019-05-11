//
//  CDTheme+CoreDataProperties.swift
//  
//
//  Created by Thea Birk Berger on 5/10/19.
//
//

import Foundation
import CoreData


extension CDTheme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTheme> {
        return NSFetchRequest<CDTheme>(entityName: "CDTheme")
    }

    @NSManaged public var theme_ID: Int16

}
