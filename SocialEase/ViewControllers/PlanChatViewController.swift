//
//  PlanChatViewController.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class PlanChatViewController: UIViewController, PlanViewControllerContext, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var enterTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    private var _plan: Plan!

    var plan: Plan {
        get {
            return _plan
        }
        set(newValue) {
            _plan = newValue
            ChatEntry.getChatEntriesForPlan(plan.pfObject.objectId!, usersInPlan: _plan.users!) { (chatEntries, error) -> () in
                if (chatEntries != nil) {
                    self.chatEntries = chatEntries
                } else {
                    print("Error getting chat entries for plan")
                }
            }
        }
    }
    
    var chatEntries: [ChatEntry]? {
        didSet {
            
        }
    }

    // MARK: - Lifecylce methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // table view delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatEntries?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let chatEntry = chatEntries![indexPath.row]
        let chatEntryUserId = chatEntry.user.pfUser!.objectId!
        let currentUserId = User.currentUser!.pfUser!.objectId!
        if (chatEntryUserId == currentUserId) {
            let cell = tableView.dequeueReusableCellWithIdentifier("ChatCurrentUserCell") as! ChatCurrentUserCell
            cell.chatEntry = chatEntry
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ChatFriendCell") as! ChatFriendCell
            cell.chatEntry = chatEntry
            return cell
        }
    }
}
