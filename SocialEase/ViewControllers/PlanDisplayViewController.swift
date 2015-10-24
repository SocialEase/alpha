//
//  PlanDisplayViewController.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/23/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class PlanDisplayViewController: UIViewController {

    @IBOutlet weak var sampleDisplayLabel: UILabel!

    var pageIndex: Int!
    var pageTitle: String! {
        didSet {
            sampleDisplayLabel?.text = pageTitle
        }
    }

    var planStatus: PlanStatus?

    var userPlanList: [Plan]? {
        didSet {
            // @todo: Connect with a view implementation
            sampleDisplayLabel?.text = userPlanList?[0].name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()

        fetchUserPlans()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupUI() {
        sampleDisplayLabel?.text = pageTitle
    }

    private func fetchUserPlans() {
        UserPlans.getUserPlanForStatus(planStatus!) { (userPlans: [Plan]?, error: NSError?) -> () in
            if let plans = userPlans {
                print(plans)
                self.userPlanList = plans
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

}
