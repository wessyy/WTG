//
//  ViewController.swift
//  WhereToGo
//
//  Created by Wesley Chan on 7/16/16.
//  Copyright © 2016 Wesley Chan, Andie Linker. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
            print("Object has been saved")
        }
        self.setupView()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupView() {
        let path = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("introvid", ofType: "mov")!)
        let player = AVPlayer(URL: path)
        let newLayer = AVPlayerLayer(player: player)
        newLayer.frame = self.videoView.frame
        self.videoView.layer.addSublayer(newLayer)
        newLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.WTGTextCenter(self.videoView)
        player.play()
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoDidPlayToEnd:", name: "AVPlayerItemDidPlayToEndTimeNotification", object: player.currentItem)
        
        self.createWTGButtons(self.videoView)
    }
    
    // Loop the video
    func videoDidPlayToEnd(notification: NSNotification) {
        let player: AVPlayerItem = notification.object as! AVPlayerItem
        player.seekToTime(kCMTimeZero)
    }
    
    func WTGTextCenter(containerView: UIView!) {
        let half: CGFloat = 1.0/2.0
        
        let wtgLabel = UILabel()
        wtgLabel.text = "Where To Go"
        wtgLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 30.0)
        wtgLabel.backgroundColor = UIColor.clearColor()
        wtgLabel.textColor = UIColor(red: (52/255.0), green: (152/255.0), blue: (219/255.0), alpha:1)
        wtgLabel.sizeToFit()
        wtgLabel.textAlignment = NSTextAlignment.Center
        wtgLabel.frame.origin.x = (containerView.frame.size.width - wtgLabel.frame.size.width) * half
        wtgLabel.frame.origin.y = (containerView.frame.size.height - wtgLabel.frame.size.height) * (1.0/5.0)
        containerView.addSubview(wtgLabel)
    }
    
    func createWTGButtons(containerView: UIView!) {
        let margin: CGFloat = 15.0
        let middleSpacing: CGFloat = 7.5
        
        let signIn = UIButton()
        signIn.setTitle("Sign In", forState: .Normal)
        signIn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        signIn.backgroundColor = UIColor.greenColor()
        signIn.frame.size.width = (((containerView.frame.size.width - signIn.frame.size.width) - (margin * 2)) / 2 - middleSpacing)
        signIn.frame.size.height = 40.0
        signIn.frame.origin.x = margin
        signIn.frame.origin.y = containerView.frame.size.height - signIn.frame.size.height - 25
        
        signIn.addTarget(self, action: "signInButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(signIn)
        
        let register = UIButton()
        register.setTitle("Register", forState: .Normal)
        register.setTitleColor(UIColor.blackColor(), forState: .Normal)
        register.backgroundColor = UIColor.greenColor()
        register.frame.size.width = (((containerView.frame.size.width - register.frame.size.width) - (margin * 2)) / 2 - middleSpacing)
        register.frame.size.height = 40.0
        register.frame.origin.x = containerView.frame.size.width - register.frame.size.width - margin
        register.frame.origin.y = containerView.frame.size.height - register.frame.size.height - 25
        
        register.addTarget(self, action: "registerButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(register)
    }
    
    func signInButtonPressed(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC: SignUpViewController = storyBoard.instantiateViewControllerWithIdentifier("signUp") as! SignUpViewController
        signUpVC.buttonTitlePressed = sender.titleLabel?.text
        
         
        let navigationController = UINavigationController(rootViewController: signUpVC)
        
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func registerButtonPressed(sender: UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC: SignUpViewController = storyBoard.instantiateViewControllerWithIdentifier("signUp") as! SignUpViewController
        
        let navigationController = UINavigationController(rootViewController: signUpVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
        

    }

}

