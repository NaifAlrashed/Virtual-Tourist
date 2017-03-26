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
    
    func getImagesFromNetwork (lat: Double, lon: Double, collectionView: UICollectionView, locationPin: Pin, completion: @escaping(_ image: UIImage) -> Void) {
        
        let _ = client.getPhotos(lat: lat, lon: lon, completionHandler: { image, count in
            DispatchQueue.main.async {
                print("inside controller")
                completion(image)
                let photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: self.appDelegate.persistentContainer.viewContext) as! Photo
                let data = UIImagePNGRepresentation(image)
                photo.path = data! as NSData?
                locationPin.addToPhotos(photo)
                if count == 1 {
                    self.appDelegate.saveContext()
                    collectionView.reloadData()
                    
                }
            }
        })
    }
    
    func getImages (lat: Double, lon: Double, collectionView: UICollectionView, completion: @escaping (_ image: UIImage) -> Void) {
        
        let pin = getPin(lat: lat, lon: lon)
        
        let photosFetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let photoPredicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
        photosFetchRequest.predicate = photoPredicate
        let photos = try? appDelegate.persistentContainer.viewContext.fetch(photosFetchRequest)
        print("photos count = \(photos?.count)")
        
        if (photos?.isEmpty)! {
            //get images from webservice
            getImagesFromNetwork(lat: lat, lon: lon, collectionView: collectionView, locationPin: pin, completion: completion)
        } else {
            
            print("using core data")
            for photo in photos! {
                let somePhoto = photo as! Photo
                let image = UIImage(data: somePhoto.path as! Data)!
                completion(image)
            }
        }
    }
    func getPin(lat: Double, lon: Double) -> Pin {
        let fr: NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "latitude = %@ AND longitude = %@", argumentArray: [lat, lon])
        fr.predicate = predicate
        let pins = try? appDelegate.persistentContainer.viewContext.fetch(fr)
        return pins!.first!
    }
}
