//
//  ViewController.swift
//  ExpatLog
//
//  Created by Alexis Chen on 11/17/18.
//  Copyright © 2018 Alexis Chen. All rights reserved.
//  chenming@usc.edu

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userToken: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let mapVC = segue.destination as? MapViewController {
//            mapVC.userToken = self.userToken
//        }
//    }
    //IBAction
    @IBAction func signupButtonClicked(_ sender: UIButton) {
        if let username = usernameTextField?.text, let password = passwordTextField?.text {
            if !username.isEmpty && !password.isEmpty {
                Auth.auth().createUser(withEmail: username, password: password) { (user, error) in
                    if user != nil {
                        self.displayConfirmMessage(title: "Sign up successful!", message: "Please log in")
//                        usernameTextField!.text = user.email
//                        passwordTextField!.text = password
                        
                    } else if let error = error{
                        switch AuthErrorCode(rawValue: error._code){
                        case .emailAlreadyInUse?:
                            self.displayAlertMessage(usermessage: "Email is already in use")
                            break
                        case .invalidEmail?:
                            self.displayAlertMessage(usermessage: "Email format is invalid")
                            break
                        case .networkError?:
                            self.displayAlertMessage(usermessage: "Network error pls try again")
                            break
                        case .weakPassword?:
                            self.displayAlertMessage(usermessage: "Your Password is too weak")
                            break
                        default:
                            self.displayAlertMessage(usermessage: "UnKnown Error")
                            break
                            
                        }
                    }
                }
            } else {
                displayAlertMessage(usermessage: "Please input correct username and password")
            }
        } else {
            displayAlertMessage(usermessage: "Please input correct username and password")
        }
       
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if let username = usernameTextField?.text, let password = passwordTextField?.text {
            Auth.auth().signIn(withEmail: username, password: password, completion: { (user, error) in
                //load user data
                if let user = user {
                    MarkersModel.sharedInstance.setUserToken(token: user.uid)
                    self.performSegue(withIdentifier: "LoginSuccessSegue", sender: self)
                } else if let error = error {
                    self.displayAlertMessage(usermessage: error.localizedDescription)
                }
            })
        } else {
            displayAlertMessage(usermessage: "Please input correct username and password")
        }
    }
    
    //helper func
    func displayConfirmMessage(title: String, message: String) {
        let confirmAlert = UIAlertController(title: title,  message: message,  preferredStyle: .alert);
        let okAction = UIAlertAction(title: "ok", style: .default){action in
            self.dismiss(animated: true, completion: nil);
        }
        confirmAlert.addAction(okAction);
        self.present(confirmAlert, animated: true, completion: nil);
    }
    
    func displayAlertMessage(usermessage: String)
    {
        let myAlert = UIAlertController(title: "Oopsie", message: usermessage, preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title:"ok", style: UIAlertAction.Style.default, handler:nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }
    
    
}

