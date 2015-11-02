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

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "planStatusDidUpdate:", name: SEAPlanStatusDidChangeNotification.Name, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newPlanCreated:", name: SEAPlanCreatedNotification.Name, object: nil)
    }

    override func viewDidAppear(animated: Bool) {
        viewActive = true
    }
    override func viewDidDisappear(animated: Bool) {
        viewActive = false
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - View Actions
    @IBAction func planDetailsTapped(sender: UIButton) {
        selectedPlanIndex = 0
        presentPlanTabbarControllerForSelectedPlan()
    }

    // MARK: - Notification methods
    func planStatusDidUpdate(notification: NSNotification) {

        let fromStatus = notification.userInfo?[SEAPlanStatusDidChangeNotification.UserInfoKeys.FromStatus] as? Int
        let toStatus = notification.userInfo?[SEAPlanStatusDidChangeNotification.UserInfoKeys.ToStatus] as? Int
        let plan = notification.userInfo?[SEAPlanStatusDidChangeNotification.UserInfoKeys.PlanObject] as? Plan

        if let fromStatus = fromStatus, let plan = plan {
            if planStatus?.rawValue == fromStatus {
                // remove plan from plan list
                userPlanList = userPlanList?.filter { $0.id! != plan.id! }
            }
        }

        if let toStatus = toStatus, let plan = plan {
            if planStatus?.rawValue == toStatus {
                addNewPlanToUserPlanList(plan)
            }
        }
    }

    func newPlanCreated(notification: NSNotification) {
        let newplanStatus = notification.userInfo?[SEAPlanCreatedNotification.UserInfoKeys.PlanStatus] as? Int
        let newPlan = notification.userInfo?[SEAPlanCreatedNotification.UserInfoKeys.PlanObject] as? Plan
        if let newplanStatus = newplanStatus, let newPlan = newPlan {
            if planStatus?.rawValue == newplanStatus {
                addNewPlanToUserPlanList(newPlan)
            }
        }
    }

    func addNewPlanToUserPlanList(plan: Plan) {
        // add plan to plan list
        var newUserPlanList = [Plan]()
        if let userPlans = userPlanList {
            newUserPlanList = userPlans
            newUserPlanList.insert(plan, atIndex: 0)
        } else {
            userPlanList = [plan]
        }
        userPlanList = newUserPlanList.sort { $0.occuranceDateTime?.compare($1.occuranceDateTime!) == NSComparisonResult.OrderedAscending }
    }

    // MARK: - Helper methods
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
            appFlow.pushPlanViewController(userPlanList![selectedPlanIndex!])
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
