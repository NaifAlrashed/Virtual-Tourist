//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/21/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var path: NSData?
    @NSManaged public var pin: Pin?

}
