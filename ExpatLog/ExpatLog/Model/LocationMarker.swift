//
//  LocationMarker.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/17/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//  chenming@usc.edu

import Mapbox

class LocationMarker: MGLPointAnnotation {
    
//    var coordinate: CLLocationCoordinate2D
//    var title:String?
//    var subtitle: String?
    
    //custom properties
    var annotationUID: String!
    var image:UIImage?
    var imgDescription: String?

    override init() {
        super.init()
        self.image = UIImage(named: "World")
    }
    
    init(uid: String) {
        super.init()
        self.annotationUID = uid
        self.image = UIImage(named: "World")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
//        self.coordinate = coordinate
//        self.title = title
//        self.subtitle = subtitle
//        self.imgDescription = ""
//        self.image = UIImage(named: "World")
//    }
}
