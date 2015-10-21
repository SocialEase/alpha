//
//  WelcomeViewController.swift
//  SocialEase
//
//  Created by Uday on 10/18/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var hiThereLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func styleView() {
        self.view.backgroundColor = UIColor.sea_primaryColor()
        hiThereLabel.textColor = UIColor.sea_primaryLabelColor()

        registerButton.setTitleColor(UIColor.sea_unselectedButtonColor(), forState: UIControlState.Normal)
        registerButton.setTitleColor(UIColor.sea_selectedButtonColor(), forState: UIControlState.Highlighted)
        
        loginButton.setTitleColor(UIColor.sea_unselectedButtonColor(), forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.sea_selectedButtonColor(), forState: UIControlState.Highlighted)
    }
    
    override func viewDidLayoutSubviews() {
        self.styleView()
    }

    @IBAction func onLoginTap(sender: AnyObject) {
        performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    @IBAction func onRegisterTap(sender: AnyObject) {
        performSegueWithIdentifier("registerSegue", sender: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
