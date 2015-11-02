//
//  BusinessDetailsViewController.swift
//  SocialEase
//
//  Created by Mo, Kevin on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    // MARK: Outlets
    @IBOutlet weak var businessInfoTableView: UITableView!

    // MARK: Other
    var activity: Activity!

    struct ViewConstants {
        static let DetailsTableViewCells: [BusinessDetailVCCellIdentifiers] = [.BusinessDetailViewCell, .BusinessMapTableViewCell, .BusinessAddressTableViewCell, .BusinessPhoneTableViewCell]
        static let EstimatedRowHeight = CGFloat(100)
    }

    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        title = activity.name

        setUpBusinessTableConfig()
    }

    // MARK: - Table view delegate and  datasource methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch ViewConstants.DetailsTableViewCells[indexPath.row] {
        case .BusinessDetailViewCell:
            let cell = businessInfoTableView.dequeueReusableCellWithIdentifier(BusinessDetailVCCellIdentifiers.BusinessDetailViewCell.rawValue, forIndexPath: indexPath) as! BusinessDetailViewCell
            cell.activity = activity
            return cell
        case .BusinessMapTableViewCell:
            let cell = businessInfoTableView.dequeueReusableCellWithIdentifier(BusinessDetailVCCellIdentifiers.BusinessMapTableViewCell.rawValue, forIndexPath: indexPath) as! BusinessMapTableViewCell
            cell.businessLocation = CLLocation(latitude: activity.coordinate.latitude, longitude: activity.coordinate.longitude)
            return cell
        case .BusinessAddressTableViewCell:
            let cell = businessInfoTableView.dequeueReusableCellWithIdentifier(BusinessDetailVCCellIdentifiers.BusinessAddressTableViewCell.rawValue, forIndexPath: indexPath) as! BusinessAddressTableViewCell
            cell.businessAddress = activity.displayAddress.joinWithSeparator(" ")
            return cell
        case .BusinessPhoneTableViewCell:
            let cell = businessInfoTableView.dequeueReusableCellWithIdentifier(BusinessDetailVCCellIdentifiers.BusinessPhoneTableViewCell.rawValue, forIndexPath: indexPath) as! BusinessPhoneTableViewCell
            cell.businessPhoneLabel.text = activity.displayPhoneNumber
            return cell
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewConstants.DetailsTableViewCells.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        businessInfoTableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let _ = businessInfoTableView.cellForRowAtIndexPath(indexPath) as? BusinessPhoneTableViewCell {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel:\(activity.displayPhoneNumber)")!)
        }
    }

    // MARK: - Helper methods
    private func setUpBusinessTableConfig() {
        businessInfoTableView.delegate = self
        businessInfoTableView.dataSource = self
        businessInfoTableView.rowHeight = UITableViewAutomaticDimension
        businessInfoTableView.estimatedRowHeight = ViewConstants.EstimatedRowHeight
        businessInfoTableView.tableFooterView = UIView(frame: CGRectZero)
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