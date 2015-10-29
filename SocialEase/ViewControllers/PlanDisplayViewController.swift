//
//  PlanDisplayViewController.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/23/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import JTProgressHUD
import Parse

class PlanDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var pageIndex: Int!
    var pageTitle: String!
    var planStatus: UserPlanStatus?
    
    var userPlanList: [Plan]? {
        didSet {
            tableView.reloadData()
        }
    }

    var viewActive = false
    var selectedPlanIndex: Int?
    var refreshControl: UIRefreshControl!

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserPlans(false)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshPlanTable:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
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
    
    // MARK: - table view delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPlanList?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlanPreviewCell", forIndexPath: indexPath) as! PlanPreviewCell
        cell.plan = userPlanList![indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("planDetailsTapped")

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedPlanIndex = indexPath.row
        presentPlanTabbarControllerForSelectedPlan()
    }
    
    // table view refresh
    func refreshPlanTable(refreshControl: UIRefreshControl) {
        fetchUserPlans(false)
        refreshControl.endRefreshing()
    }    
}
