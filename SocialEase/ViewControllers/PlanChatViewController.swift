//
//  PlanChatViewController.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class PlanChatViewController: UIViewController, PlanViewControllerContext {

    // MARK: - Outlet Properties

    // MARK: - variables
    private var _plan: Plan!

    var plan: Plan {
        get {
            return _plan
        }
        set(newValue) {
            _plan = newValue
        }
    }

    // MARK: - Lifecylce methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
