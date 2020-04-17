//
//  LocationAnnotation.swift
//  FIT5120-project
//
//  Created by Simon Xie on 17/4/20.
//  Copyright © 2020 Simon Xie. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    //Class for each location
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double) {
        self.title = newTitle
        self.subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
