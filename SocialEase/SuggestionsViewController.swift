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

    @IBOutlet weak var sendButtonFooterView: UIView!
    @IBOutlet weak var sendButton: UILabel!

    // MARK: - Properties
    var groupId: Int!

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
                self.filterOptionsTableView.alpha = self.showTimeDateFilter ? 1 : 0
                self.updateFilterDisplay(self.dateTimeTextLabel, arrowLabel: self.dateTimeArrowIndicator, filterState: self.showTimeDateFilter)
                self.view.layoutIfNeeded()
            }
        }
    }

    private var dateFilterList = [SuggestionsFilter]()
    private var activityTypeFilterList = [SuggestionsFilter]()
    
    var activity : SEAActivity? {
        didSet {
            
        }
    }

    var suggestedActivities: [(activity: SEAActivity, selected: Bool)]? {
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

    // MARK: - Lifecyle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // hard coded for now
        groupId = 12345

        // Do any additional setup after loading the view, typically from a nib.
        setupTableViews()

        initDateFilter()
        initActivityTypeFilter()
        setupFilterViews()
        fetchSuggestions()
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
        if tableView == filterOptionsTableView {
            for i in 0 ..< filterTableViewData.count {
                filterTableViewData[i].isSelected = false
            }
            filterTableViewData[indexPath.row].isSelected = true
            filterTextLabel.text = filterTableViewData[indexPath.row].displayName

            showActivityTypeFilter ? activityTypeViewTapped(nil) : timeViewTapped(nil)
        } else {
            suggestedActivities?[indexPath.row].selected = !(suggestedActivities?[indexPath.row].selected)!
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            
            // TODO: kevin go to detail view
            let appFlow = AppFlow()
            
            let activity = suggestedActivities?[indexPath.row].activity
            
            appFlow.presentBusinessDetail(activity!)
            
            // kevin done
        }

    }

    // MARK: - View actions
    @IBAction func timeViewTapped(sender: UITapGestureRecognizer?) {
        showActivityTypeFilter = false
        showTimeDateFilter = !showTimeDateFilter
        !showActivityTypeFilter && !showTimeDateFilter ? fetchSuggestions() : ()
    }

    @IBAction func activityTypeViewTapped(sender: UITapGestureRecognizer?) {
        showTimeDateFilter = false
        showActivityTypeFilter = !showActivityTypeFilter
        !showActivityTypeFilter && !showTimeDateFilter ? fetchSuggestions() : ()
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
            //@todo: Add logic to create a new activity and send PUSH notification to users
        }
    }

    // MARK: - Internal helpe methods
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

    private func fetchSuggestions() {
        JTProgressHUD.showWithStyle(JTProgressHUDStyle.Gradient)
        SEAActivity.getSuggestedActivitiesForGroupId(groupId) { (suggestedActivities: [SEAActivity]?, error: NSError?) -> () in
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print ("Hello")
    }
}

