//
//  PlanDisplayViewController.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/23/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import JTProgressHUD

class PlanDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex: Int!
    var pageTitle: String! {
        didSet {
//            sampleDisplayLabel?.text = pageTitle
        }
    }

    var planStatus: UserPlanStatus?

    var userPlanList: [Plan]? {
        didSet {
            if (userPlanList?.count ?? 0) > 0 {
                print(userPlanList?[0].name)
                // @todo: Connect with a view implementation
                sampleDisplayLabel?.text = userPlanList?[0].name
                userPlanList?[0].setImageOnUIImageView(sampleImageView)

                // getting plan users
                userPlanList?[0].getPlanUsersWithCompletion { (users: [User]?, error: NSError?) -> () in
                    if let users = users {
                        for user in users {
                            print(user.name)
                        }
                    }
                }
            }
        }
    }
    var viewActive = false

    var selectedPlanIndex: Int?

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()

        fetchUserPlans(false)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 190
//        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewDidAppear(animated: Bool) {
        viewActive = true
    }
    override func viewDidDisappear(animated: Bool) {
        viewActive = false
    }

    @IBAction func planDetailsTapped(sender: UIButton) {
        print("planDetailsTapped")
        selectedPlanIndex = 0
        presentPlanTabbarControllerForSelectedPlan()
    }
    
    private func setupUI() {
//        sampleDisplayLabel?.text = pageTitle
    }

    private func fetchUserPlans(cached: Bool) {
        JTProgressHUD.showWithStyle(JTProgressHUDStyle.Gradient)
        UserPlans.getUserPlanForStatus(planStatus!, usingCache: cached) { (userPlans: [Plan]?, error: NSError?) -> () in
            if let plans = userPlans {
                self.userPlanList = plans
                self.tableView.reloadData()
                JTProgressHUD.hide()
            }
        }
    }

    private func presentPlanTabbarControllerForSelectedPlan() {
        if selectedPlanIndex != nil && selectedPlanIndex! < userPlanList?.count {
            let appFlow = AppFlow()
            appFlow.presentPlanViewController(userPlanList![selectedPlanIndex!])
        }
    }
    
    // table view delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = userPlanList != nil
            ? userPlanList!.count
            : 0
        print("Number of user plans = \(numRows)")
        return numRows
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlanPreviewCell", forIndexPath: indexPath) as! PlanPreviewCell
        cell.plan = userPlanList![indexPath.row]
        return cell
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
