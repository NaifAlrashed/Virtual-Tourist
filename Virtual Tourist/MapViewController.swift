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
    
    var barButtonItem: UIBarButtonItem!
    var isEdit = false
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
        changeToEdit()
    }
    
    func changeToDone() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(changeToEdit))
        isEdit = false
    }
    func changeToEdit() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeToDone))
        isEdit = true
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        print(#function)
        if sender.state == .began {
            return
        }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
                
        let pin = PinAnnotation(coordinate: locationCoordinate)
        mapView.addAnnotation(pin)
        
        let aPin = Pin(context: delegate.persistentContainer.viewContext)
        aPin.latitude = locationCoordinate.latitude
        aPin.longitude = locationCoordinate.longitude
        
        
        delegate.saveContext()
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if (view.annotation is PinAnnotation) {
            if isEdit {
                let controller = storyboard?.instantiateViewController(withIdentifier: "Pictures") as! PhotoAlbumViewController
                controller.lat = view.annotation?.coordinate.latitude
                controller.lon = view.annotation?.coordinate.longitude
                controller.coordinate = view.annotation?.coordinate
                navigationController?.pushViewController(controller, animated: true)
            } else {
                guard let coordinate = view.annotation?.coordinate else {
                    print("found nil annotation!")
                    return
                }
                let savedPin = ImageCache.shared.getPin(lat: coordinate.latitude, lon: coordinate.longitude)
                delegate.persistentContainer.viewContext.delete(savedPin)
                mapView.removeAnnotation(view.annotation!)
            }
        }
    }

}

