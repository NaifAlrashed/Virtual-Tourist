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

class PicturesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    var lat: Double? = nil
    var lon: Double? = nil
    var locationPin: Pin? = nil
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var coordinate: CLLocationCoordinate2D? = nil
    
    var fetchResult : NSFetchedResultsController<NSFetchRequestResult>!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    var images: [UIImage] = [UIImage]()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    private let client = Client()
    private let imageCache = ImageCache.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let pin = PinAnnotation(coordinate: coordinate!)
        mapView.addAnnotation(pin)
        mapView.selectAnnotation(pin, animated: true)

        imageCache.getImages(lat: (coordinate?.latitude)!, lon: (coordinate?.longitude)!, collectionView: collectionView) { image in
            
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
        let selectedImageData = images[indexPath.row] as! NSData
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "path = %@", argumentArray: [selectedImageData])
        
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
        imageCache.getImagesFromNetwork(lat: coordinate!.latitude, lon: coordinate!.longitude, collectionView: collectionView, locationPin: pin) { image in
            
            self.images.append(image)
        }
    }
    
    private func updatePageNumberAndClearPhotos(of pin: Pin) {
        pin.pageNumber += 1
        pin.photos = NSSet()
    }
    private func clearAndReloadCollectionView() {
        images = []
        collectionView.reloadData()
    }
}
