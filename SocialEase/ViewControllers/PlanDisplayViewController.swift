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
    var pageTitle: String!
    var planStatus: UserPlanStatus?
    
    var userPlanList: [Plan]?
    var viewActive = false
    var selectedPlanIndex: Int?

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserPlans(false)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableViewAutomaticDimension
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("planDetailsTapped")

        selectedPlanIndex = indexPath.row
        presentPlanTabbarControllerForSelectedPlan()
    }
}
