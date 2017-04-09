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
    
    var insertedIndexPaths: [IndexPath]? = nil
    var deletedIndexPaths: [IndexPath]? = nil
    
    var lat: Double? = nil
    var lon: Double? = nil
    var locationPin: Pin? = nil
    var numberOfRowsInSection = 0
    
    
    var fetchedResultsController: NSFetchedResultsController<Photo>? {
        didSet {
            fetchedResultsController?.delegate = self
        }
    }
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var coordinate: CLLocationCoordinate2D? = nil
    var a = true
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let pin = PinAnnotation(coordinate: coordinate!)
        mapView.addAnnotation(pin)
        mapView.selectAnnotation(pin, animated: true)
        mapView.setCenter(pin.coordinate, animated: true)

        let photoFetchRequest = ImageCache.shared.getPhotoFetchRequest(lat: lat!, lon: lon!)
        fetchedResultsController = NSFetchedResultsController<Photo>(fetchRequest: photoFetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultsController?.performFetch()
        
        if fetchedResultsController?.sections?[0].numberOfObjects == 0 {
            ImageCache.shared.getImagesFromNetwork(lat: lat!, lon: lon!, locationPin: ImageCache.shared.getPin(lat: lat!, lon: lon!))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotNumOfPics), name: Notification.Name(Constants.numberOfPicsNotificationName), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(Constants.numberOfPicsNotificationName), object: nil)
    }
    func gotNumOfPics() {
        guard Constants.numberOfPics != nil else {
            print("pics are nil!!!")
            return
        }
        numberOfRowsInSection = Constants.numberOfPics!
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! Image
        guard let fetchedResultsController = fetchedResultsController,
            let sections = fetchedResultsController.sections,
            sections.count > 0,
            sections[0].numberOfObjects > 0, sections[0].numberOfObjects > indexPath.row else {
                
            cell.imageView.image = #imageLiteral(resourceName: "placeHolder")
            cell.loading.startAnimating()
            cell.loading.isHidden = false
            return cell
        }
        let photo = fetchedResultsController.object(at: indexPath)
        let image = UIImage(data: photo.path! as Data)!
        cell.imageView?.image = image
        cell.loading.stopAnimating()
        cell.loading.isHidden = true
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = fetchedResultsController?.object(at: indexPath) else {
            print("couldn't find the photo")
            return
        }
        numberOfRowsInSection = 0
        appDelegate.persistentContainer.viewContext.delete(photo)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if numberOfRowsInSection == 0 {
            return fetchedResultsController?.sections?[0].numberOfObjects ?? 0
        }
        return numberOfRowsInSection
    }

    
    @IBAction func refresh(_ sender: Any) {
        let pin = ImageCache.shared.getPin(lat: coordinate!.latitude, lon: coordinate!.longitude)
//        updatePageNumberAndClearPhotos(of: pin)
        print("before change pageNumber = \(pin.pageNumber)")
        pin.pageNumber = pin.pageNumber + 1
        pin.photos = NSSet()
        appDelegate.saveContext()
        print("now pageNumber = \(pin.pageNumber)")
        appDelegate.saveContext()
        ImageCache.shared.getImagesFromNetwork(lat: coordinate!.latitude, lon: coordinate!.longitude, locationPin: pin)
    }
    
    private func updatePageNumberAndClearPhotos(of pin: Pin) {
        print("pageNumber beforeChange: \(pin.pageNumber)")
        pin.pageNumber = pin.pageNumber + 1
        print("pageNumber afterChange: \(pin.pageNumber)")
        pin.photos = NSSet()
        appDelegate.saveContext()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {
                print("error: indexPath not found")
                return
            }
            deletedIndexPaths?.append(indexPath)
        case .insert:
            guard let newIndexPath = newIndexPath else {
                print("error: newIndexPath not found")
                return
            }
            insertedIndexPaths?.append(newIndexPath)
        default:
            print("shouldn't be here")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView.performBatchUpdates({
            if let deletedIndexPaths = self.deletedIndexPaths {
                for index in deletedIndexPaths {
                    self.collectionView.deleteItems(at: [index])
                }
                self.deletedIndexPaths = [IndexPath]()
            }
            
            if let insertedIndexPaths = self.insertedIndexPaths, Constants.numberOfPics != nil {
                for index in insertedIndexPaths {
                    self.collectionView.reloadItems(at: [index])                    
                }
                self.insertedIndexPaths = [IndexPath]()
            }
        }, completion: nil)
        print("success")
    }
    
    deinit {
        Constants.numberOfPics = nil
    }

}
