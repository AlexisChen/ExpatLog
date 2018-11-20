//
//  MarkersModel.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/17/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//  chenming@usc.edu

import MapKit
import FirebaseFirestore

class MarkersModel {
    static let sharedInstance: MarkersModel = MarkersModel()
    private var markers: [LocationMarker]!
    private(set) var userToken: String?
    private var database: Firestore!
//    private(set) var currentIndex :Int = 0
//    private var filePath :String?
    
    private let kLongitudeKey = "longitude"
    private let kLatitudeKey = "latitude"
    private let kImageKey = "image"
    private let kTitleKey = "title"
    private let kDescriptionKey = "description"
    
    init() {
        markers = [LocationMarker]()
        database = Firestore.firestore()
    }
    
    func setUserToken(token: String!) {
        userToken = token
         //loadData through user token if exist, skip if no annotation created
        if let userToken = userToken {
            database.collection("Annotation").document(userToken).getDocument { (snapshot, error) in
                if let snapshot = snapshot, let annotations = snapshot.get("annotations") as? [[String:Any]] {
                    for annotation in annotations {
                        var newMarker = LocationMarker()
                        newMarker.location = CLLocationCoordinate2D(latitude: annotation[self.kLatitudeKey] as! Double, longitude: annotation[self.kLongitudeKey] as! Double)
                        if let imageData = Data(base64Encoded: annotation[self.kImageKey] as! String, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
                            newMarker.image = UIImage(data: imageData)!
                        }
                        newMarker.title = annotation[self.kTitleKey] as? String
                        newMarker.description = annotation[self.kDescriptionKey] as? String
                        self.markers.append(newMarker)
                    }
                } else if let error = error{
                    print("error when pulling data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func save() {
        //connect to firebase
    
        //write data
    }
}
