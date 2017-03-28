//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Naif Alrashed on 3/8/17.
//  Copyright © 2017 Naif Alrashed. All rights reserved.
//

import Foundation
import UIKit

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
            static let NumberOfResultsPerPage = "per_page"
            static let pageNumber = "page"
        }
        
        // MARK: Flickr Parameter Values
        struct FlickrParameterValues {
            static let APIKey = "6c9e1421510633e2a5e6a747aefd0cf3"
            static let ResponseFormat = "json"
            static let DisableJSONCallback = "1" /* 1 means "yes" */
            static var latitude = ""
            static var longitude = ""
            static let searchMethod = "flickr.photos.search"
            static let NumberOfResultsPerPage = "21"
            static var pageNumber = "1"
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
