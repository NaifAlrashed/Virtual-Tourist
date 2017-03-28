//
//  PituresCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/8/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    var lat: Double? = nil
    var lon: Double? = nil
    var locationPin: Pin? = nil
    var dbImageData: [NSData] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var coordinate: CLLocationCoordinate2D? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    var images: [UIImage] = [UIImage]()
    
    private let imageCache = ImageCache.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let pin = PinAnnotation(coordinate: coordinate!)
        mapView.addAnnotation(pin)
        mapView.selectAnnotation(pin, animated: true)
        mapView.setCenter(pin.coordinate, animated: true)

        imageCache.getImages(lat: (coordinate?.latitude)!, lon: (coordinate?.longitude)!, collectionView: collectionView) { image, data in
            
            self.dbImageData.append(data)
            self.images.append(image)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! Image
        guard indexPath.row < images.count else {
            cell.imageView.image = #imageLiteral(resourceName: "placeHolder")
            cell.loading.startAnimating()
            cell.loading.isHidden = false
            return cell
        }
        cell.imageView?.image = images[indexPath.row]
        cell.loading.stopAnimating()
        cell.loading.isHidden = true
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "path = %@", argumentArray: [dbImageData[indexPath.row]])
        fetchRequest.predicate = predicate
//        let deleteFetchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            let photos = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            appDelegate.persistentContainer.viewContext.delete(photos.first!)
            try appDelegate.persistentContainer.viewContext.save()
            clearAndReloadCollectionFromDB()
            print("finish deletion")
        } catch {
            print("couldn't get the photos")
            return
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (images.count == 0) ? 21: images.count
    }

    
    @IBAction func refresh(_ sender: Any) {
        let pin = imageCache.getPin(lat: coordinate!.latitude, lon: coordinate!.longitude)
        updatePageNumberAndClearPhotos(of: pin)
        clearAndReloadCollectionView()
        print("now pageNumber = \(pin.pageNumber)")
        appDelegate.saveContext()
        imageCache.getImagesFromNetwork(lat: coordinate!.latitude, lon: coordinate!.longitude, collectionView: collectionView, locationPin: pin) { image, data in
            
            self.dbImageData.append(data)
            self.images.append(image)
        }
    }
    
    private func updatePageNumberAndClearPhotos(of pin: Pin) {
        pin.pageNumber += 1
        pin.photos = NSSet()
    }
    private func clearAndReloadCollectionView() {
        images = []
        dbImageData = []
        collectionView.reloadData()
    }
    
    private func clearAndReloadCollectionFromDB() {
        clearAndReloadCollectionView()
        
        imageCache.getImages(lat: (coordinate?.latitude)!, lon: (coordinate?.longitude)!, collectionView: collectionView) { image, data in
            
            self.dbImageData.append(data)
            self.images.append(image)
        }
    }
}
