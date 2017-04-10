//
//  imageCache.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/24/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ImageCache {
    static let shared = ImageCache()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let client = Client.shared
    
    private init() {}
    
    func getImagesFromNetwork (lat: Double, lon: Double, locationPin: Pin) {
        var isFirst = true
        Constants.FlickrParameterValues.pageNumber = String(locationPin.pageNumber)
        let _ = client.getPhotos(lat: lat, lon: lon, completionHandler: { image, count in
            if count < 21 && isFirst {
                DispatchQueue.main.async {
                    locationPin.pageNumber = 0
                }
            }
            DispatchQueue.main.async {
                let photo = Photo(context: self.appDelegate.persistentContainer.viewContext)
                let data = UIImagePNGRepresentation(image)
                photo.path = data! as NSData?
                locationPin.addToPhotos(photo)
                if count == 1 {
                    self.appDelegate.saveContext()
                }
            }
            isFirst = false
        })
    }
    

    func getPhotoFetchRequest(lat: Double, lon: Double) -> NSFetchRequest<Photo> {

        let pin = getPin(lat: lat, lon: lon)
        let photoFetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let photoPredicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
        _ = NSSortDescriptor(key: "path", ascending: true)
        photoFetchRequest.predicate = photoPredicate
        photoFetchRequest.sortDescriptors = []
        return photoFetchRequest
    }
    
    func getPin(lat: Double, lon: Double) -> Pin {
        let fr: NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "latitude = %@ AND longitude = %@", argumentArray: [lat, lon])
        fr.predicate = predicate
        let pins = try? appDelegate.persistentContainer.viewContext.fetch(fr)
        return pins!.first!
    }
    
}
