//
//  ViewController.swift
//  SocialEaseSuggestionsWorkflow
//
//  Created by Amay Singhal on 10/17/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import Parse
import JTProgressHUD

enum SuggestionsViewTableType {
    case SuggestionsTable, FilterTable
}


class SuggestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var activityTypeView: UIView!
    @IBOutlet weak var timeInformationView: UIView!
    @IBOutlet weak var activityTypeTextLabel: UILabel!
    @IBOutlet weak var activityTypeArrowIndicator: UILabel!
    @IBOutlet weak var dateTimeTextLabel: UILabel!
    @IBOutlet weak var dateTimeArrowIndicator: UILabel!
    @IBOutlet weak var filterOptionsTableView: UITableView!
    @IBOutlet weak var suggestedPlaceTableView: UITableView!
    @IBOutlet weak var actvitiyDatePicker: UIDatePicker!
    @IBOutlet weak var activtyDatePickerView: UIView!

    @IBOutlet weak var sendButtonFooterView: UIView!
    @IBOutlet weak var sendButton: UILabel!

    // MARK: - Properties
    var groupId: Int!
    var group: UserGroup!

    private var showActivityTypeFilter = false {
        didSet {
            filterOptionsTableView.reloadData()
            UIView.animateWithDuration(0.5) { () -> Void in
                self.filterOptionsTableView.alpha = self.showActivityTypeFilter ? 1 : 0
                self.updateFilterDisplay(self.activityTypeTextLabel, arrowLabel: self.activityTypeArrowIndicator, filterState: self.showActivityTypeFilter)
                self.view.layoutIfNeeded()
            }
        }
    }

    private var showTimeDateFilter = false {
        didSet {
            filterOptionsTableView.reloadData()
            UIView.animateWithDuration(0.5) { () -> Void in
                self.dateTimeTextLabel.text = DateUtils.getSystemStyleDisplayDate(self.actvitiyDatePicker.date, dateStyle: .MediumStyle)
                self.activtyDatePickerView.alpha = self.showTimeDateFilter ? 1 : 0
                self.updateFilterDisplay(self.dateTimeTextLabel, arrowLabel: self.dateTimeArrowIndicator, filterState: self.showTimeDateFilter)
                self.view.layoutIfNeeded()
            }
        }
    }

    private var dateFilterList = [SuggestionsFilter]()
    private var activityTypeFilterList = [SuggestionsFilter]()

    var suggestedActivities: [(activity: Activity, selected: Bool)]? {
        didSet {
            suggestedPlaceTableView?.reloadData()
            updateSendButtonActiveState()
        }
    }

    private var filterTableViewData: [SuggestionsFilter] {
        if showActivityTypeFilter {
            return activityTypeFilterList
        } else if showTimeDateFilter {
            return dateFilterList
        } else {
            return [SuggestionsFilter]()
        }
    }

    private var filterTextLabel: UILabel {
        if showActivityTypeFilter {
            return activityTypeTextLabel
        } else if showTimeDateFilter {
            return dateTimeTextLabel
        } else {
            return UILabel()
        }
    }

    private var selectedAcitivitiesCount: Int? {
        return suggestedActivities?.filter( { $0.selected } ).count
    }

    private struct ViewConstants {
        static let SendButtonText = "SEND"
        static let NothingSelectedText = "Nothing selected!"
    }

    private var activityTypeSetByUser: String?
    private var activityDateTimeSetByUser: NSDate?

    // MARK: - Lifecyle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        setupTableViews()

        initDateFilter()
        initActivityTypeFilter()
        setupFilterViews()
        fetchSuggestionsWithActivityType(nil, forDateTime: nil)

        actvitiyDatePicker.minimumDate = NSDate()
        dateTimeTextLabel.text = DateUtils.getSystemStyleDisplayDate(actvitiyDatePicker.date, dateStyle: .MediumStyle)
    }

    // MARK: - Table view ds and delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == suggestedPlaceTableView {
            return suggestedActivities?.count ?? 0
        } else {
            return filterTableViewData.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == suggestedPlaceTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(SuggestedPlaceViewCell.Identifier, forIndexPath: indexPath) as! SuggestedPlaceViewCell
            cell.activity = suggestedActivities?[indexPath.row].activity
            cell.cellSelected = suggestedActivities?[indexPath.row].selected
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(FilterOptionViewCell.Identifier, forIndexPath: indexPath) as! FilterOptionViewCell
            cell.filter = filterTableViewData[indexPath.row]
            return cell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == filterOptionsTableView { // select action on cell for filter table
            for i in 0 ..< filterTableViewData.count {
                filterTableViewData[i].isSelected = false
            }

            filterTableViewData[indexPath.row].isSelected = true
            filterTextLabel.text = filterTableViewData[indexPath.row].displayName
            activityTypeSetByUser = filterTableViewData[indexPath.row].displayName

            showActivityTypeFilter ? activityTypeViewTapped(nil) : timeViewTapped(nil)
        } else {  // select action on cell for suggestions table (as that is the only other table on this view)
            suggestedActivities?[indexPath.row].selected = !(suggestedActivities?[indexPath.row].selected)!
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            
            // TODO: kevin go to detail view
            //let appFlow = AppFlow()
            
            //let activity = suggestedActivities?[indexPath.row].activity
            
            //appFlow.presentBusinessDetail(activity!)
            
            // kevin done
        }

    }

    // MARK: - View actions
    @IBAction func timeViewTapped(sender: UITapGestureRecognizer?) {
        showActivityTypeFilter = false
        showTimeDateFilter = !showTimeDateFilter

    }

    @IBAction func activityTypeViewTapped(sender: UITapGestureRecognizer?) {
        showTimeDateFilter = false
        showActivityTypeFilter = !showActivityTypeFilter
        !showActivityTypeFilter && !showTimeDateFilter ? fetchSuggestionsWithActivityType(activityTypeTextLabel.text, forDateTime: actvitiyDatePicker.date) : ()
    }

    @IBAction func sendBottonTapped(sender: UITapGestureRecognizer) {
        if selectedAcitivitiesCount == 0 {
            sendButton.text = ViewConstants.NothingSelectedText
            sendButton.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.7)
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                self.sendButton.alpha = 0
                }) { (success: Bool) -> Void in
                    self.sendButton.text = ViewConstants.SendButtonText
                    self.sendButton.alpha = 1
                    self.updateSendButtonActiveState()
            }
        } else {
            // 1. Save activity objects
            Activity.saveActivities(suggestedActivities?.filter( { $0.selected }).map({ $0.activity })) { (activities: [Activity]?, error: NSError?) -> () in
                if let activities = activities {
                    // 2. Create/Save plan objects with associated activities object ids
                    Plan.createPlanWithName(self.activityTypeTextLabel.text!, atOccuranceTime: self.actvitiyDatePicker.date, forGroup: self.group, withActivities: activities) { (plan: Plan?, error: NSError?) -> () in
                        if let plan = plan {
                            // 3. Create/Save UserPlans and UserActivities objects
                            UsersPlanActivity.createPlanAndActivitiesForGroup(self.group, withPlan: plan, andActivities: activities, byOrganizer: PFUser.currentUser()!) { (success: Bool, error: NSError?) -> () in
                                if success {
                                    // 4. @todo: Uday to add implementation for push notifications here
                                    self.sendPushNotifications(plan, users: self.group.users!)
                                    print("Saved all the data on Parse... Ready for PUSH notifications")
                                } else {
                                    print(error?.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
            AppFlow().presentHomePageViewController()
        }
    }

    private func sendPushNotifications(plan: Plan?, users: [User]) {
        let pfUserIds = users.map{ $0.pfUser!.objectId! }
            .map{"'\($0)'"}
            .joinWithSeparator(",")
        let predicate = NSPredicate(format: "userId in {\(pfUserIds)}")
        let query = PFQuery(className: "_Installation", predicate: predicate)
        
        var data = [NSObject : AnyObject]()
        data["alert"] = "Hey guys"
        PFPush.sendPushDataToQueryInBackground(query, withData: data) { (success, error) -> Void in
            print(error?.localizedDescription)
            print(success)
        }
    }
    
    // MARK: - Internal helper methods
    private func updateFilterDisplay(filterTextLabel: UILabel, arrowLabel: UILabel, filterState: Bool) {
        if filterState {
            filterTextLabel.textColor = UIColor(red: 255/255, green: 153/255, blue: 90/255, alpha: 1)
            arrowLabel.textColor = UIColor(red: 255/255, green: 153/255, blue: 90/255, alpha: 1)
            arrowLabel.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI_2))
        } else {
            filterTextLabel.textColor = UIColor.darkGrayColor()
            arrowLabel.textColor = UIColor.darkGrayColor()
            arrowLabel.transform = CGAffineTransformMakeRotation(CGFloat(0))
        }
    }

    private func initDateFilter() {
        dateFilterList = DisplayDateFilter.getDateFilterListFromDate(NSDate())
    }

    private func initActivityTypeFilter() {
        activityTypeFilterList = DisplayActivityTypeFilter.getActivityTypeFilterList()
    }

    private func fetchSuggestionsWithActivityType(activityType: String?, forDateTime dateTime: NSDate?) {
        JTProgressHUD.showWithStyle(JTProgressHUDStyle.Gradient)

        Activity.getSuggestedActivitiesForGroup(group, andActivityType: activityType, onDateTime: dateTime) { (suggestedActivities: [Activity]?, error: NSError?) -> () in
            JTProgressHUD.hide()
            if let suggestedActivities = suggestedActivities {
                self.suggestedActivities = suggestedActivities.map { ($0, false) }
            }
        }
    }

    private func updateSendButtonActiveState() {
        if selectedAcitivitiesCount > 0 {
            sendButton.textColor = UIColor(red: 255/255, green: 204/255, blue: 102/255, alpha: 1)
            sendButtonFooterView.backgroundColor = UIColor(red: 0/255, green: 114/255, blue: 187/255, alpha: 0.95)
        } else {
            sendButton.textColor = UIColor.darkGrayColor()
            sendButtonFooterView.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 0.95)
        }
    }

    private func setupTableViews() {
        // setup suggestions table
        suggestedPlaceTableView.delegate = self
        suggestedPlaceTableView.dataSource = self
        suggestedPlaceTableView.rowHeight = UITableViewAutomaticDimension
        suggestedPlaceTableView.estimatedRowHeight = SuggestedPlaceViewCell.EstimateRowHeight
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: suggestedPlaceTableView.bounds.width, height: 30))
        footerView.backgroundColor = UIColor.clearColor()
        suggestedPlaceTableView.tableFooterView = footerView

        // setup filter table
        filterOptionsTableView.delegate = self
        filterOptionsTableView.dataSource = self
        filterOptionsTableView.rowHeight = UITableViewAutomaticDimension
        filterOptionsTableView.estimatedRowHeight = FilterOptionViewCell.EstimateRowHeight
    }

    private func setupFilterViews() {
        activityTypeView.addBorderToViewAtPosition(.Bottom)
        timeInformationView.addBorderToViewAtPosition(.Bottom)
        timeInformationView.addBorderToViewAtPosition(.Left)
    }
}

