//
//  MapViewController.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/17/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//  chenming@usc.edu

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var mapCellButton: UIButton!
    
    var mapView :MGLMapView!
    var mapCellView :MapCalloutView!
    var userToken :String!
    
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

    }
    
    //delegate functions
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        mapCellView =  MapCalloutView(representedObject: annotation)
        mapCellView.cellButton.addTarget(self, action: #selector(pushDetailVC), for: .touchUpInside)
//        mapCellView.cellButton = self.mapCellButton
        return mapCellView
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        print("finally found you ")
    }
 
    //override function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController {
            detailVC.completionHandler = {(title: String?, description: String?, image: UIImage?) in
                if let title=title, let description = description, let image = image {
                    //add to model
                    
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
        let newAnnotation = MGLPointAnnotation()
        newAnnotation.coordinate = CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        newAnnotation.title = "New location marked!"
        newAnnotation.subtitle = "Tap to edit details"
        mapView.addAnnotation(newAnnotation)
    }
    //helper objc functions
    @objc func pushDetailVC() {
        mapCellButton.sendActions(for: .touchUpInside)
        print("push detail vc")
    }
    
}
