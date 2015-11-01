//
//  LoginViewController.swift
//  SocialEase
//
//  Created by Uday on 10/17/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    static var completionCallback: (() -> ())?
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerNewUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
    }
    
    func styleView() {
        self.view.backgroundColor = UIColor.sea_primaryColor()
        
        loginButton.setTitleColor(UIColor.sea_unselectedButtonColor(), forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.sea_selectedButtonColor(), forState: UIControlState.Highlighted)
    }
    
    override func viewDidLayoutSubviews() {
        self.styleView()
    }
    
    @IBAction func didLogin(sender: AnyObject) {
        // TODO: add 2 step authentication
        let phoneNumber = phoneNumberTextField.text!
        
        User.logInInBackground(phoneNumber) { (user, error) -> () in
            if (error != nil) {
                let alert = UIAlertController(title: "Error", message: "Couldnt login", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                    handler: { (alertAction) -> Void in })
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                User.currentUser = user
                let appFlow = AppFlow()
                appFlow.presentHomePageViewController()
            }
        }
    }
        
    @IBAction func didRegisterNewUser(sender: AnyObject) {
        performSegueWithIdentifier("loginToRegisterSegue", sender: self)
    }
    
    @IBAction func backButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func openGroupsController() {
        nextAction()
    }
    
    func nextAction() {
        if let completionCallback = LoginViewController.completionCallback {
            completionCallback()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
