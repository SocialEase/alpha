//
//  PlanInformationViewController.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class PlanInformationViewController: UIViewController, PlanViewControllerContext {

    // MARK: - Outlet Properties
    @IBOutlet weak var pendingPlanView: UIView!
    @IBOutlet weak var planImageView: UIImageView!

    // MARK: - variables
    private var _plan: Plan! {
        didSet {
            // kick off ui update around this property
            isViewLoaded() ? updateUI() : ()
        }
    }

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
        updateUI()
    }

    override func viewDidAppear(animated: Bool) {

    }
    // MARK: - Helper functions
    private func updateUI() {


    }

    private func setImageView() {

        plan.setImageOnUIImageView(planImageView)
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
