//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/6/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fr: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let pins = try? delegate.persistentContainer.viewContext.fetch(fr) {
            for pin in pins {
                let annotation = PinAnnotation(pin: pin)
                mapView.addAnnotation(annotation)
            }
        }
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
        
        let aPin = Pin(context: delegate.persistentContainer.viewContext)
        aPin.latitude = locationCoordinate.latitude
        aPin.longitude = locationCoordinate.longitude
        
        
        delegate.saveContext()
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view.annotation is PinAnnotation) {
            let controller = storyboard?.instantiateViewController(withIdentifier: "Pictures") as! PhotoAlbumViewController
            controller.lat = view.annotation?.coordinate.latitude
            controller.lon = view.annotation?.coordinate.longitude
            controller.coordinate = view.annotation?.coordinate
            mapView.deselectAnnotation(view.annotation, animated: true)
            navigationController?.pushViewController(controller, animated: true)
        }
    }

}

