//
//  LoginViewController.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/17/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var completionCallback: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Login"
        
        // So view doesn't hide behind navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginTap(sender: AnyObject) {
        nextAction()
    }
    
    func nextAction() {
        if let completionCallback = completionCallback {
            completionCallback()
        }
    }
    
}
