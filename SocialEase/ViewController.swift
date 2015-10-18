//
//  ViewController.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/17/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationBarDelegate {
    
    var completionCallback: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Social Ease"
        
        // So view doesn't hide behind navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onNextTap(sender: AnyObject) {
        nextAction()
    }
    
    func nextAction() {
        if let completionCallback = completionCallback {
            completionCallback()
        }
    }
    
}
