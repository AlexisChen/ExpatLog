//
//  DetailViewController.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/19/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    typealias DetailCompletionHandler = (String?, String?, UIImage?)->Void
    var completionHandler: DetailCompletionHandler?
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTitleTextField: UITextField!
    @IBOutlet weak var detaIlDesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        detailImageView.image = image
        addImageButton.isHidden = true;
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if let completionHandler = completionHandler {
            completionHandler(detailTitleTextField.text, detaIlDesTextView.text, detailImageView.image)
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
