//
//  Client.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/8/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation
import UIKit

class Client {
    
    static let shared = Client()
    
    private init () {}
    
    func getPhotos(lat: Double, lon: Double, completionHandler: @escaping (_ image: UIImage, _ count: Int) -> Void) -> [Data]? {
        print(#function)
        let parameters: [String:String] = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.searchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.latitude: "\(lat)",
            Constants.FlickrParameterKeys.longitude: "\(lon)",
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
            Constants.FlickrParameterKeys.NumberOfResultsPerPage: Constants.FlickrParameterValues.NumberOfResultsPerPage,
            Constants.FlickrParameterKeys.pageNumber: Constants.FlickrParameterValues.pageNumber
        ]
        
        let request = URLRequest(url: URL(string: "\(Constants.Flickr.APIBaseURL)\(escapedParameters(parameters))")!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("error: \(error!)")
                return
            }
            
            let photoRefence: [String:Any]!
            
            do {
                photoRefence = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    as! [String:Any]
            } catch let error {
                print("could't parse json: \(error)")
                return
            }
            
            guard let photo = photoRefence["photos"] as? [String:Any] else {
                print("could'nt get photo from \(photoRefence)")
                return
            }
            
            guard let photos = photo["photo"] as? [Any] else {
                print("could'nt get photos from \(photo)")
                return
            }
            if photos.isEmpty {
                print("no photos")
                return
            }
            print(photos.count)
            var count = photos.count
            for somePhoto in photos {
                guard let photoReference = somePhoto as? [String:Any] else {
                    print("couldn't convert array to dictionary")
                    return
                }
                
                guard let serverID = photoReference["server"] as? String else {
                    print("could'nt get server from \(photoReference)")
                    return
                }

                guard let id = photoReference["id"] as? String else {
                    print("could'nt get id from \(photoReference)")
                    return
                }

                guard let secret = photoReference["secret"] as? String else {
                    print("could'nt get secret from \(photoReference)")
                    return
                }

                guard let farm = photoReference["farm"] as? Int else {
                    print("could'nt get farm from \(photoReference)")
                    return
                }
                let photoUrl = "https://farm\(farm).staticflickr.com/\(serverID)/\(id)_\(secret).jpg"
                
                print(photoUrl)

                let imageData: Data
                do {
                     imageData = try Data(contentsOf: URL(string: photoUrl)!)
                } catch {
                    print("couldn't convert \(photoUrl)")
                    return
                }
                
                let image = UIImage(data: imageData)
                print(photoUrl)
                if let image = image {
                    completionHandler(image, count)
                } else {
                    print("image is nil!!!!!!!!!!!! \(photoUrl)")
                }
                count = count - 1
            }
        }        
        task.resume()
        
        return nil
    }
    
    private func escapedParameters(_ parameters: [String:String]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
}
