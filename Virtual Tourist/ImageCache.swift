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
        
        Constants.FlickrParameterValues.pageNumber = String(locationPin.pageNumber)
        let _ = client.getPhotos(lat: lat, lon: lon, completionHandler: { image, count in
            if count < 21 {
                DispatchQueue.main.async {
                    locationPin.pageNumber = 0
                }
            }
            DispatchQueue.main.async {
                let photo = Photo(context: self.appDelegate.persistentContainer.viewContext)
                let data = UIImagePNGRepresentation(image)
                photo.path = data! as NSData?
                locationPin.addToPhotos(photo)
                self.appDelegate.saveContext()
                if count == 1 {
                    
                }
            }
        })
    }
    
//    func getImages (lat: Double, lon: Double, collectionView: UICollectionView) {
//        
//        let pin = getPin(lat: lat, lon: lon)
//        
//        let photosFetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
//        let photoPredicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
//        photosFetchRequest.predicate = photoPredicate
//        let photos = try? appDelegate.persistentContainer.viewContext.fetch(photosFetchRequest)
//        print("photos count = \(photos?.count)")
//        
//        if (photos?.isEmpty)! {
//            //get images from webservice
//            getImagesFromNetwork(lat: lat, lon: lon, collectionView: collectionView, locationPin: pin)
//        } else {
//            print("using core data")
//            for photo in photos! {
//                let image = UIImage(data: photo.path as! Data)!
//            }
//        }
//    }
    func getPhotoFetchRequest(lat: Double, lon: Double) -> NSFetchRequest<Photo> {

        let pin = getPin(lat: lat, lon: lon)
        let photoFetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let photoPredicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
        let sortDescriptor = NSSortDescriptor(key: "path", ascending: true)
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
