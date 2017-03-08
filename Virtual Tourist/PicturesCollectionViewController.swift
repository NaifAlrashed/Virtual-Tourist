//
//  PituresCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/8/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit
import MapKit
class PicturesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var lat: Double? = nil
    var lon: Double? = nil
    
    var coordinate: CLLocationCoordinate2D? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    var images: [UIImage] = [UIImage]()
    
    private let client = Client()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pin = PinAnnotation(coordinate: coordinate!)
        mapView.addAnnotation(pin)
        mapView.selectAnnotation(pin, animated: true)
        
        if let lat = lat,
            let lon = lon {
            
            
            let _ = client.getPhotos(lat: lat, lon: lon, completionHandler: { image, count in
                DispatchQueue.main.async {
                    print("inside controller")
                    self.images.append(image)
                    if count == 1 {
                        print("count == 1!, length of images = \(self.images.count)")
                        self.collectionView.reloadData()
                    }
                }
            })
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! Image
        
        cell.imageView?.image = images[indexPath.row]
        
        return cell
    }

    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }


}
