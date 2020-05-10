//
//  CheckList+CoreDataProperties.swift
//  FIT5120-project
//
//  Created by Simon Xie on 7/5/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//
//

import Foundation
import CoreData


extension CheckList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckList> {
        return NSFetchRequest<CheckList>(entityName: "CheckList")
    }

    @NSManaged public var averageTime: Double
    @NSManaged public var fatigueLevel: String?
    @NSManaged public var questionOne: Bool
    @NSManaged public var rating: Int32
    @NSManaged public var time: String?
    @NSManaged public var weatherTemp: String?
    @NSManaged public var questionTwo: Bool
    @NSManaged public var questionThree: Bool
    @NSManaged public var questionFive: Bool
    @NSManaged public var questionFour: Bool

}
