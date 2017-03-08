//
//  PituresCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/8/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import UIKit

class PicturesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var lat: Double? = nil
    var lon: Double? = nil
    
    var images: [UIImage] = [UIImage]()
    
    private let client = Client()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lat = lat,
            let lon = lon {
            
            let _ = client.getPhotos(lat: lat, lon: lon, completionHandler: { image in
                DispatchQueue.main.async {
                    self.images.append(image)
                }
            })
        }
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
