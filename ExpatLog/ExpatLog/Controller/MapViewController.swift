//
//  MapViewController.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/17/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//  chenming@usc.edu

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate, MarkersModelDelegate {
    
    var mapView :MGLMapView!
    var mapCellView :MapCalloutView!
    var userToken :String!
    var markersModel = MarkersModel.sharedInstance
    var currentAnnotation :LocationMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds)
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView!)
        //changing map style
        mapView.styleURL = URL(string:"mapbox://styles/cynthiaghf/cjogt98l8146m2spz6imrmyo1")
        //set location to user current location
        mapView.userTrackingMode = .follow
//        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.74699, longitude: -73.98742), zoomLevel: 9, animated: false)
        //set delegate for annotation
        mapView.delegate = self
        mapView.showsUserLocation = true
        markersModel.delegate = self;
    }
    
    //delegate functions
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        //set currentAnnotation
        currentAnnotation = annotation as? LocationMarker
        mapCellView =  MapCalloutView(representedObject: annotation)
        mapCellView.cellButton.addTarget(self, action: #selector(pushDetailVC), for: .touchUpInside)
        mapCellView.cellTitle.text = currentAnnotation?.title
        mapCellView.cellImageView.image = currentAnnotation?.image
        return mapCellView
    }
    
//    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
//        print("finally found you ")
//    }
 
    func addAnnotations(_ annotations: [LocationMarker]) {
        mapView.addAnnotations(annotations)
    }
    
    //override function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController {
            detailVC.currentAnnotation = self.currentAnnotation
            detailVC.completionHandler = {(title: String?, description: String?, image: UIImage?, imageUpdated: Bool) in
                if let title=title, let description = description, let image = image {
                    //add to model
                    self.currentAnnotation?.title = title
                    self.currentAnnotation?.imgDescription = description
                    self.currentAnnotation?.image = image
                    self.markersModel.updateMarker(marker: self.currentAnnotation!, imageUpdated:imageUpdated)
                    //update view
                    self.mapCellView.cellTitle.text = title
                    self.mapCellView.cellImageView.image = image
                }
            }
        }
    }
    
    //IBAction
    @IBAction func longPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: view)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        //create annotation, add to view and model
        let newAnnotation = LocationMarker()
        newAnnotation.annotationUID = UUID().uuidString
        newAnnotation.coordinate = CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        newAnnotation.title = "New location marked!"
        newAnnotation.subtitle = "Tap to edit details"
        markersModel.addMarker(newMarker: newAnnotation)
        mapView.addAnnotation(newAnnotation)
    }
    //helper objc functions
    @objc func pushDetailVC() {
        self.performSegue(withIdentifier: "MapToDetailSegue", sender: self)
    }
    
}
