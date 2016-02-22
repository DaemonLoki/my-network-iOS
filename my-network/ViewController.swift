//
//  ViewController.swift
//  my-network
//
//  Created by Stefan Blos on 30.01.16.
//  Copyright © 2016 Stefan Blos. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }

    @IBAction func fbBtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                print("successfully logged in with facebook. \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        print("Login failed! \(error)")
                        // TODO handle error
                    } else {
                        print("Logged in! \(authData)")
                        
                        // error handling: if let provider = authData.provider as String
                        let user = ["provider": authData.provider!]
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                    
                })
            }
        }
    }
    
    @IBAction func attemptLogin(sender: UIButton!) {
        
        if let email = emailField.text where email != "", let password = passwordField.text where password != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: password, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch(errorCode) {
                        case .UserDoesNotExist:
                            DataService.ds.REF_BASE.createUser(email, password: password, withValueCompletionBlock: { error, result in
                                if error != nil {
                                    self.showErrorAlert("Could not create account", message: "Please try again!")
                                    
                                    // TODO handle other errors
                                } else {
                                    NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                    
                                    DataService.ds.REF_BASE.authUser(email, password: password, withCompletionBlock: { err, authData in
                                        // error handling: if let provider = authData.provider as String
                                        let user = ["provider": authData.provider!]
                                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                                    })
                                    
                                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                }
                            })
                        case .InvalidEmail:
                            self.showErrorAlert("Invalid Email", message: "Please enter a valid mail address")
                        case .InvalidPassword:
                            self.showErrorAlert("Invalid Password", message: "Password was wrong. Please enter valid password")
                        default:
                            self.showErrorAlert("Error", message: "Error occured during login")
                        }
                    }
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
            
        } else {
            showErrorAlert("Email and Password Required", message: "You must enter an email and a password to log in")
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
}

    