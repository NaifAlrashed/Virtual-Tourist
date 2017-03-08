//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/8/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation


    struct Constants {
        
        // MARK: Flickr
        struct Flickr {
            static let APIBaseURL = "https://api.flickr.com/services/rest/"
        }
        
        
        // MARK: Flickr Parameter Keys
        struct FlickrParameterKeys {
            static let Method = "method"
            static let APIKey = "api_key"
            static let latitude = "lat"
            static let longitude = "lon"
            static let Format = "format"
            static let NoJSONCallback = "nojsoncallback"
        }
        
        // MARK: Flickr Parameter Values
        struct FlickrParameterValues {
            static let APIKey = "519bef96f3f1304e71258378481aea09"
            static let ResponseFormat = "json"
            static let DisableJSONCallback = "1" /* 1 means "yes" */
            static var latitude = ""
            static var longitude = ""
            static let searchMethod = "flickr.photos.search"
        }
        
        // MARK: Flickr Response Keys
        struct FlickrResponseKeys {
            static let Status = "stat"
            static let Photos = "photos"
            static let Photo = "photo"
            static let Title = "title"
            static let MediumURL = "url_m"
        }
        
        // MARK: Flickr Response Values
        struct FlickrResponseValues {
            static let OKStatus = "ok"
        }
    }
