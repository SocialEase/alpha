//
//  PlanInformationViewController.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import MapKit
import Parse

enum ActivityTableCellType: String {
    case ActivityViewCell
}

class PlanInformationViewController: UIViewController, PlanViewControllerContext, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, ActivityViewCellDelegate {

    // MARK: - Outlet Properties
    @IBOutlet weak var pendingPlanView: UIView!
    @IBOutlet weak var pendingPlanInfoView: UIView!
    @IBOutlet weak var planImageView: UIImageView!
    @IBOutlet weak var organizersProfileImage: UIImageView!
    @IBOutlet weak var organizersNameLabel: UILabel!
    @IBOutlet weak var planCommentLabel: UILabel!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var planDateLabel: UILabel!
    @IBOutlet weak var activePlanView: UIView!
    @IBOutlet weak var activitiesTableView: UITableView!

    @IBOutlet weak var actPlanNameLabel: UILabel!
    @IBOutlet weak var actDateTimeLabel: UILabel!
    @IBOutlet weak var actPlanOrganizerNameLabel: UILabel!

    // MARK: variables
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

    var planOrganizer: User? {
        didSet {
            if let _ = planOrganizer {
                setupOrganizerUI()
            }
        }
    }

    var userActivities: [UserActivity]? {
        didSet {
            updateTableView()
        }
    }

    struct ViewConstants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
    }

    // MARK: - Lifecylce methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup delgate and datatsources
        setupTableView()

        // Do any additional setup after loading the view.
        updateUI()

        // @todo: Get plan users and show them in view
        // plan.getPlanUsersWithCompletion { (users: [User]?, error: NSError?) -> () in
        //
        // }

        // setup organizers information
        plan.getPlanOganizerWithCompletion{ (user: User?, error: NSError?) -> () in
            self.planOrganizer = user
        }
    }

    override func viewWillDisappear(animated: Bool) {
        UserActivity.saveObjectsInBackground(userActivities, withCompletion: nil)
    }

    // MARK: - View Actions
    @IBAction func acceptButtonTapped(sender: UIButton) {
        UserPlans.updateUserPlanStatusForPlan(plan, withStatus: UserPlanStatus.Active) { (success: Bool, error: NSError?) -> () in
            if success {
                // Update plan & call delegate method
                self.postPlanUpdateNotificationForChangedPlan(self.plan, fromStatus: self.plan.currentUserStatus ?? UserPlanStatus.Pending, toStatus: .Active)
                // Show active plan view
                UIView.animateWithDuration(1.0) { () -> Void in
                    self.pendingPlanView.alpha = 0
                    self.plan.currentUserStatus = .Active
                    self.updateActivePlanViewUI(true)
                }
            }
        }
    }

    @IBAction func declineButtonTapped(sender: UIButton) {
        // @todo: handle declined event
    }

    // MARK: - Table View delegate/datasource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userActivities?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = ActivityTableCellType.ActivityViewCell
        let cell = activitiesTableView.dequeueReusableCellWithIdentifier(cellType.rawValue, forIndexPath: indexPath) as! ActivityViewCell
        cell.cellIndexPath = indexPath
        cell.usrActivity = userActivities![indexPath.row]
        cell.delegate = self
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    // MARK: - Helper functions
    private func updateUI() {
        if plan.currentUserStatus == .Pending {
            updatePendingPlanViewUI()
        } else {
            updateActivePlanViewUI(false)
        }
    }

    func postPlanUpdateNotificationForChangedPlan(plan: Plan, fromStatus: UserPlanStatus, toStatus: UserPlanStatus) {
        plan.currentUserStatus = toStatus

        var userInfo = [NSObject: AnyObject]()
        userInfo[SEAPlanStatusDidChangeNotification.UserInfoKeys.PlanObject] = plan
        userInfo[SEAPlanStatusDidChangeNotification.UserInfoKeys.FromStatus] = fromStatus.rawValue
        userInfo[SEAPlanStatusDidChangeNotification.UserInfoKeys.ToStatus] = toStatus.rawValue
        NSNotificationCenter.defaultCenter().postNotificationName(SEAPlanStatusDidChangeNotification.Name, object: nil, userInfo: userInfo)
    }

    // MARK: Active activity view update functions
    private func updateActivePlanViewUI(createUserActitivities: Bool) {
        activePlanView.alpha = 1
        pendingPlanView.alpha = 0

        if userActivities == nil {
            if createUserActitivities {
                Activity.getActivitiesForObjectIdList(plan.activityIds!) { (activities: [Activity]?, error: NSError?) -> () in
                    if let activities = activities {
                        self.userActivities = activities.map { UserActivity(userId: (PFUser.currentUser()?.objectId!)!, planId: self.plan.id!, activity: $0) }
                    }
                }
            } else {
                UserActivity.fetchActivitiesForUser(PFUser.currentUser()!, inPlan: plan) { (userActivities: [UserActivity]?, error: NSError?) -> Void in
                    if let userActivities = userActivities {
                        self.userActivities = userActivities
                    }
                }
            }
        }

        // set other outlets
        actPlanNameLabel.text = plan.name
        actDateTimeLabel.text = DateUtils.getSystemStyleDisplayDate(plan.occuranceDateTime!)
    }

    private func updateTableView() {
        if let _ = userActivities {
            activitiesTableView.reloadData()
        }
    }

    // MARK: - Activity view cell delegate
    func activityViewCell(activityViewCell: UITableViewCell, didUpdateActivityVoteToVote vote: UserActivityVote, atIndexPath indexpath: NSIndexPath) {
        userActivities?[indexpath.row].vote = vote
        activitiesTableView.reloadRowsAtIndexPaths([indexpath], withRowAnimation: .None)
    }

    // MARK: Pending activity view update functions
    private func updatePendingPlanViewUI() {
        activePlanView.alpha = 0
        pendingPlanView.alpha = 1

        // set background
        setBackgroundImageView()

        // set other outlets
        planNameLabel.text = plan.name
        planDateLabel.text = DateUtils.getSystemStyleDisplayDate(plan.occuranceDateTime!)
        planCommentLabel.text = plan.comment
    }

    private func setBackgroundImageView() {
        ViewTransformationUtils.addBlurToView(pendingPlanInfoView, frame: view.frame)
        plan.setImageOnUIImageView(planImageView)
    }

    private func setupOrganizerUI() {
        ViewTransformationUtils.convertViewToCircle(organizersProfileImage, borderColor: UIColor.darkGrayColor(), borderWidth: 5)
        if let profileImgUrl = planOrganizer?.profileImageUrl {
            organizersProfileImage.setImageWithURL(profileImgUrl)
        }

        organizersNameLabel.text = planOrganizer?.name
        actPlanOrganizerNameLabel.text = planOrganizer?.name
    }

    // MARK: Other methods
    private func setupTableView() {
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        activitiesTableView.rowHeight = UITableViewAutomaticDimension
        activitiesTableView.estimatedRowHeight = ActivityViewCell.EstimatedRowHeight
        activitiesTableView.tableFooterView = UIView(frame: CGRectZero)
        activitiesTableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
