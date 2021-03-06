//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 4/9/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var path: NSData?
    @NSManaged public var pin: Pin?

}
