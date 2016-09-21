//
//  SignUpViewController.swift
//  WhereToGo
//
//  Created by Wesley Chan on 7/25/16.
//  Copyright © 2016 Wesley Chan, Andie Linker. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var buttonTitlePressed: String?
    var isSignIn: Bool!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.determineSignInOrRegister()
//        if buttonTitlePressed != nil {
//            if buttonTitlePressed == "Sign In" {
//                isSignIn = true
//                print(buttonTitlePressed)
//                print(isSignIn)
//                
//            }
//        }else{
//            isSignIn = false
//            print("Register")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func done(sender: UIBarButtonItem) {
        if isSignIn == false {
            if self.username.text == "" {
                self.username.layer.borderColor = UIColor.redColor().CGColor
                self.username.layer.borderWidth = 1.0
                self.showAlert("Missing Fields Required", message: "Fill in or select missing Field(s) in red")
            }
            if self.password.text == "" {
                self.password.layer.borderColor = UIColor.redColor().CGColor
                self.password.layer.borderWidth = 1.0
                self.showAlert("Missing Fields Required", message: "Fill in or select missing Field(s) in red")
            }
            else {
                let user = PFUser()
                user.username = self.username.text
                user.password = self.password.text
            
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo["error"] as? NSString
                    
                        self.showAlert("Error Registering", message: String(errorString))
                    }
                    else {
                        print("Register Succeeded")
                    }
                }
            }
        } else {
            PFUser.logInWithUsernameInBackground(self.username.text!, password: self.password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    print("Login Successful")
                    self.loginSuccessful()
                } else {
                    if let errorInfo = error?.userInfo["error"] as? String {
                        self.showAlert("Sign Up Failed", message: errorInfo)
                    }
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func determineSignInOrRegister() {
        super.viewDidLoad()
        
        if buttonTitlePressed != nil {
            if buttonTitlePressed == "Sign In" {
                isSignIn = true
                self.navigationController!.topViewController!.title = "Sign In"
                print(buttonTitlePressed)
                print(isSignIn)
                
            }else if buttonTitlePressed == "Register"{
                isSignIn = false
                self.navigationController!.topViewController!.title = "Register"
                print("Register")
            }
        } else {
            isSignIn = false
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loginSuccessful() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC: LocationViewController = storyBoard.instantiateViewControllerWithIdentifier("MapViewController") as! LocationViewController
//        let navigationController = UINavigationController(rootViewController: mapVC)
        
        self.presentViewController(mapVC, animated: true, completion: nil)
    }
}