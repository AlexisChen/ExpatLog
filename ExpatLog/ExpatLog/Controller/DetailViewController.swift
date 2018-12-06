//
//  DetailViewController.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/19/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PostDetailDelegate, DropdownViewDelegate {

    typealias DetailCompletionHandler = (String?, String?, UIImage?, Bool)->Void
    var completionHandler: DetailCompletionHandler?
    var imageUpdated:Bool = false;
    var currentAnnotation:LocationMarker!
    var userToken: String!
    var collectionsModel = CollectionsModel.sharedInstance
    var isInCollection = false
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTitleTextField: UITextField!
    @IBOutlet weak var detailDesTextView: UITextView!
    @IBOutlet weak var addToCollectionImageView: UIImageView!
    var collectionIconButton: addToCollectionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.image = currentAnnotation.image
        detailTitleTextField.text = currentAnnotation.title
        detailDesTextView.text = currentAnnotation.imgDescription
        //place the addToCollectionButton
        collectionIconButton = addToCollectionButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        collectionIconButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionIconButton)
        collectionIconButton.centerXAnchor.constraint(equalTo: addToCollectionImageView.centerXAnchor).isActive = true
        collectionIconButton.centerYAnchor.constraint(equalTo: addToCollectionImageView.centerYAnchor).isActive = true
        
        collectionIconButton.topAnchor.constraint(equalTo: addToCollectionImageView.topAnchor).isActive = true
        collectionIconButton.leftAnchor.constraint(equalTo: addToCollectionImageView.leftAnchor).isActive = true
        collectionIconButton.dropView.dropdownViewDelegate = self
//        myFirstButton.addTarget(self, action: ), forControlEvents: .TouchUpInside)
        updateInCollection()
        collectionIconButton.addTarget(self, action: #selector(addToCollectionButtonClicked), for: .touchUpInside)
        collectionsModel.postdetailDelegate = self
    }
    
    // MARK: - Delegate
    func updateInCollection() {
        isInCollection = collectionsModel.markerInCollections(inMarker: currentAnnotation.annotationUID)
        //get list of collection names
        let collectionNames = collectionsModel.getCollectionNames()
        collectionIconButton.popDropView(collections: collectionNames)
        updateInCollectionImage()
    }
    
    func collectionSelected(atIndex index: Int) {
        //update UIImage change status
        isInCollection = true
        updateInCollectionImage()
        //add current annotation to selected collection
        collectionsModel.addMarkerToCollection(markerID: currentAnnotation.annotationUID, collectionAt: index)
        //dismiss dropview
        collectionIconButton.dismissDropDown()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        detailImageView.image = image
        addImageButton.isHidden = true;
        imageUpdated = true;
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IBAction
    
    @objc func addToCollectionButtonClicked() {
        //only works if not incollection
        if !isInCollection {
            collectionIconButton.presentDropView()
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if let completionHandler = completionHandler {
            completionHandler(detailTitleTextField.text, detailDesTextView.text, detailImageView.image, imageUpdated)
        }
    }
    
    @IBAction func addImageButtonClicked(_ sender: UIButton) {
        let Sheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        weak var weakSelf = self
        
        let selectAction = UIAlertAction(title: "Select from Library", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            weakSelf?.initPhotoPicker()
        }
        
        let takeAction = UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            weakSelf?.initCameraPicker()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel){ (action:UIAlertAction)in
            
        }
        
        Sheet.addAction(selectAction)
        Sheet.addAction(takeAction)
        Sheet.addAction(cancelAction)
        
        self.present(Sheet, animated: true, completion: nil)
    }
    
    //helper functions
    
    private func updateInCollectionImage() {
        if !isInCollection {
            addToCollectionImageView.image =  #imageLiteral(resourceName: "StarEmpty")
        } else {
            addToCollectionImageView.image = #imageLiteral(resourceName: "StarFilled")
        }
    }
    
    func initPhotoPicker(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    func initCameraPicker(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("Can not take picture")
        }
    }
    
    //helper objc function
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil {
            print("Save Failure")
        } else {
            print("Save Success")
        }
    }
    
    
}
