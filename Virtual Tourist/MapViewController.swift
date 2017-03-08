//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/6/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        print(#function)
        if sender.state == .began {
            return
        }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        print("latitude: \(locationCoordinate.latitude), longintude: \(locationCoordinate.longitude)")
        
        let pin = PinAnnotation(coordinate: locationCoordinate)
        mapView.addAnnotation(pin)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Pictures") as! PicturesCollectionViewController
        controller.lat = view.annotation?.coordinate.latitude
        controller.lon = view.annotation?.coordinate.longitude
        controller.coordinate = view.annotation?.coordinate
        navigationController?.pushViewController(controller, animated: true)
    }

}

