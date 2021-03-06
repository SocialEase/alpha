//
//  ViewController.swift
//  SocialEase
//
//  Created by Uday on 10/15/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
    }

    func styleView() {
        self.view.backgroundColor = UIColor.sea_primaryColor()

        registerButton.setTitleColor(UIColor.sea_unselectedButtonColor(), forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.sea_selectedButtonColor(), forState: UIControlState.Highlighted)        
    }

    @IBAction func didRegister(sender: AnyObject) {
        let user = User()
        user.phoneNumber = phoneNumberTextField.text
        user.name = nameTextField.text

        // TODO: disable interaction on view until signup is successful
        user.signUpInBackground { (user, error) -> Void in
            if (error != nil) {
                print(error)
                let alert = UIAlertController(title: "Error", message: "Couldnt register user", preferredStyle: UIAlertControllerStyle.Alert)
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                    handler: { (alertAction) -> Void in })
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                User.currentUser = user
                self.openCategoriesViewController()
            }
        }
    }

    @IBAction func goBackButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    func openCategoriesViewController() {
        self.performSegueWithIdentifier("categoriesViewSegue", sender: self)
    }
}

