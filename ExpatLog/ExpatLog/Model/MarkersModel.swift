//
//  MarkersModel.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/17/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//  chenming@usc.edu

import MapKit
import FirebaseFirestore
import FirebaseStorage

protocol MarkersModelDelegate: AnyObject {
    func addAnnotations(_ annotations:[LocationMarker])->Void
}


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
    private let kDescriptionKey = "imageDescription"
    
    weak var delegate: MarkersModelDelegate?
    
    init() {
        markers = [LocationMarker]()
        database = Firestore.firestore()
    }
    
    func setUserToken(token: String!) {
        userToken = token
         //loadData through user token if exist, skip if no annotation created
        if let userToken = userToken {
            database.collection("Annotation").document(userToken).collection("annotations").getDocuments { (snapshot, error) in
                if let snapshot = snapshot {
                    for annotation in snapshot.documents {
                        let annotationID = annotation.documentID
                        let annotationData = annotation.data()
                        let newMarker = LocationMarker()
                        newMarker.annotationUID = annotationID
                        let newCoord = CLLocationCoordinate2D(latitude: annotationData[self.kLatitudeKey] as! Double, longitude: annotationData[self.kLongitudeKey] as! Double)
                        newMarker.coordinate = newCoord
                        newMarker.title = annotationData[self.kTitleKey] as? String
//
                        print("\(self.userToken!)/\(annotationID).png")
                        let storageRef = Storage.storage().reference().child("\(self.userToken!)/\(annotationID).png")
                        storageRef.getData(maxSize: 1024*1024*9, completion: { (data, error) in
                            if let data = data {
                                newMarker.image = UIImage(data:data)
                            }
                            if let error = error {
                                print("error downloading image: \(error.localizedDescription)")
                            }
                        })
//                        if let imageData = Data(base64Encoded: annotationData[self.kImageKey] as! String, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
//                            newMarker.image = UIImage(data: imageData)!
//                        }
                        newMarker.imgDescription = annotationData[self.kDescriptionKey] as? String
                        self.markers.append(newMarker)
                    }
                    //add annotations to view
                    self.delegate?.addAnnotations(self.markers)
                } else if let error = error{
                    print("error when pulling data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func addMarker(newMarker: LocationMarker) {
        markers.append(newMarker)
        //upload image data to firebase storage
        let imagePath = "\(userToken!)/\(newMarker.annotationUID!).png"
        let storageRef = Storage.storage().reference(withPath: imagePath)
        if let image = newMarker.image {
            let imageData:NSData = image.pngData()! as NSData
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg";
            //uploaddata
            storageRef.putData(imageData as Data, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("error uploading image to fireStorage \(error.localizedDescription)");
                } else {
                    let imageURL = metadata!.downloadURL()!.absoluteString
                    //upload annotation data to firebase database
                    let annotationDict = [
                        self.kLongitudeKey: newMarker.coordinate.longitude,
                        self.kLatitudeKey: newMarker.coordinate.latitude,
                        self.kTitleKey: newMarker.title!,
                        self.kImageKey: imageURL,
                        self.kDescriptionKey: newMarker.imgDescription ?? ""
                    ] as [String : Any]
                self.database.collection("Annotation").document(self.userToken!).collection("annotations").document(newMarker.annotationUID!).setData(annotationDict)
                }
            }
        }
    }
    
    func updateMarker(marker: LocationMarker, imageUpdated: Bool) {
        //get market to be updated
        let updateDict = [
            self.kTitleKey: marker.title!,
            self.kDescriptionKey: marker.imgDescription ?? ""
        ]
    database.collection("Annotation").document(userToken!).collection("annotations").document(marker.annotationUID).updateData(updateDict)
        
        if imageUpdated {
            let imagePath = "\(userToken!)/\(marker.annotationUID!).png"
            let storageRef = Storage.storage().reference(withPath: imagePath)
            if let image = marker.image {
                let imageData:NSData = image.pngData()! as NSData
                let metadata = StorageMetadata()
                metadata.contentType = "image/png";
                storageRef.putData(imageData as Data, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("error uploading image to fireStorage \(error.localizedDescription)");
                    } else {
                        let imageURL = metadata!.downloadURL()!.absoluteString
                    self.database.collection("Annotation").document(self.userToken!).collection("annotations").document(marker.annotationUID!).updateData([self.kImageKey:imageURL])
                    }
                }
            }
        }
        
    }
    
    func save() {
        //write as array of dictionaries
        var data = [String: [String: Any]]()
        for marker in markers {
            // saving the image in firestore
            let imagePath = "\(UUID().uuidString)/detail.jpg"
            let storageRef = Storage.storage().reference(withPath: imagePath)
            var imageURL = ""
            if let image = marker.image {
                let imageData:NSData = image.pngData()! as NSData
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg";
                //uploaddata
                storageRef.putData(imageData as Data, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("error uploading image to fireStorage \(error.localizedDescription)");
                    } else {
                        imageURL = metadata?.downloadURL()?.absoluteString ?? "image url not available"
                        //upload data
                    }
                }
            }

            
//            var imageStr = ""
//            if let image = marker.image {
//                let imageData:NSData = image.pngData()! as NSData
//                imageStr = imageData.base64EncodedString(options: .lineLength64Characters)
//            }
            let dict = [
                kLongitudeKey: marker.coordinate.longitude,
                kLatitudeKey: marker.coordinate.latitude,
                kTitleKey: marker.title!,
                kImageKey: imageURL,
                kDescriptionKey: marker.imgDescription ?? ""
                ] as [String : Any]
            data[UUID().uuidString] = dict
        }
        //connect to firebase
        database.collection("Annotation").document(userToken!).setData(["annotations":data]){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
//        database.collection("Annotation").document(userToken!).setValue(data, forKey: "annotations")
    }
}
