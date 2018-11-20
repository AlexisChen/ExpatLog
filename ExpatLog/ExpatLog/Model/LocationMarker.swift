//
//  LocationMarker.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/17/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//  chenming@usc.edu

import MapKit

struct LocationMarker {
    var location:CLLocationCoordinate2D!
    var image:UIImage!
    var title:String!
    var description:String!
    
    init() {
        location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        image = UIImage(named: "World")
    }
}
