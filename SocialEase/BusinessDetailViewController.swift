//
//  BusinessDetailViewController.swift
//  SocialEase
//
//  Created by Mo, Kevin on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class BusinessDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var businessInfoTableView: UITableView!
    
    struct ViewConstants {
        static let DetailsTableViewCells: [BusinessDetailVCCellIdentifiers] = [.BusinessDetailViewCell, .BusinessMapTableViewCell, .BusinessAddressTableViewCell, .BusinessPhoneTableViewCell]
        static let EstimatedRowHeight = CGFloat(100)
    }
    
    var activity: SEAActivity!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBusinessTableConfig()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewConstants.DetailsTableViewCells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch ViewConstants.DetailsTableViewCells[indexPath.row] {
        case .BusinessDetailViewCell:
            let cell = businessInfoTableView.dequeueReusableCellWithIdentifier(BusinessDetailVCCellIdentifiers.BusinessDetailViewCell.rawValue, forIndexPath: indexPath) as! BusinessDetailViewCell
            cell.activity = activity
            return cell
        case .BusinessMapTableViewCell:
            let cell = businessInfoTableView.dequeueReusableCellWithIdentifier(BusinessDetailVCCellIdentifiers.BusinessMapTableViewCell.rawValue, forIndexPath: indexPath) as! BusinessMapTableViewCell
            cell.businessLocation = activity.location
            return cell
        case .BusinessAddressTableViewCell:
            let cell = businessInfoTableView.dequeueReusableCellWithIdentifier(BusinessDetailVCCellIdentifiers.BusinessAddressTableViewCell.rawValue, forIndexPath: indexPath) as! BusinessAddressTableViewCell
            cell.businessAddress = activity.location
            return cell
        case .BusinessPhoneTableViewCell:
            let cell = businessInfoTableView.dequeueReusableCellWithIdentifier(BusinessDetailVCCellIdentifiers.BusinessPhoneTableViewCell.rawValue, forIndexPath: indexPath) as! BusinessPhoneTableViewCell
            cell.businessPhoneLabel.text = "510-777-9876"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        businessInfoTableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let _ = businessInfoTableView.cellForRowAtIndexPath(indexPath) as? BusinessPhoneTableViewCell {
            //UIApplication.sharedApplication().openURL(NSURL(string: "tel:\(business.displayPhone!)")!)
            print("hello")
        }
    }
    
    private func setUpBusinessTableConfig() {
        businessInfoTableView.delegate = self
        businessInfoTableView.dataSource = self
        businessInfoTableView.rowHeight = UITableViewAutomaticDimension
        businessInfoTableView.estimatedRowHeight = ViewConstants.EstimatedRowHeight
        businessInfoTableView.tableFooterView = UIView(frame: CGRectZero)
    }

}
