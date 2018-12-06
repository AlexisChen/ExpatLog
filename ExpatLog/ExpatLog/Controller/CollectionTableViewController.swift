//
//  CollectionTableViewController.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/17/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//  chenming@usc.edu

import UIKit

class CollectionTableViewController: UITableViewController, CollectionsModelDelegate {

    var markersModel = MarkersModel.sharedInstance
    var collectionsModel = CollectionsModel.sharedInstance
    
    var collectionNames = [String]()
    private let kCellHeight: CGFloat = 80
    private var currentMarkerImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionsModel.collectionDelegate = self
        collectionsModel.loadCollections(userToken: markersModel.userToken)
        self.tableView.rowHeight = kCellHeight
    }
    // MARK: - IBAction
    @IBAction func addCollectionButtonClicked(_ sender: UIBarButtonItem) {
        //present a popup window for collection name
        let alert = UIAlertController(title: "New Collection", message: "please enter the collection name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "New Collection Name"
            textField.text = "Some default text"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let newCollectionName = alert!.textFields![0].text {
                if newCollectionName.isEmpty {
                    print("shouldn't get here bro")
                }
                self.collectionsModel.addNewCollection(name: newCollectionName)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Delegate
    func refreshCollections() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collectionNames = collectionsModel.getCollectionNames()
        return collectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath)
        cell.textLabel?.text = collectionNames[indexPath.row]
        return cell
    }

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    
    // Mark: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue
        popMarkerContents(collectionID: indexPath.row)
        self.performSegue(withIdentifier: "collectionToContentSegue", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let collectionImageVC = segue.destination as? CollectionImageTableViewController {
            collectionImageVC.images = self.currentMarkerImages
        }
        
    }
    
    // MARK: -Helpers
    func popMarkerContents(collectionID: Int) {
        let markerIDs = collectionsModel.getMarkersAtIndex(index: collectionID)
        currentMarkerImages.removeAll(keepingCapacity: false)
        for id in markerIDs {
            if let markerImage = markersModel.getMarkerImageWithID(id: id) {
                self.currentMarkerImages.append(markerImage)
            }
        }
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*

    */

}
