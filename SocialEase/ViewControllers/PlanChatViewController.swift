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
    @IBOutlet weak var enterChatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

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
    
    var chatEntries: [ChatEntry]?
    
    // MARK: - Lifecylce methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleSendButton()
        
        // table view setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // observer for keyboard pop
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        enterChatTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        takeToBottomOfTableView()
    }
    
    func styleSendButton() {
        if enterChatTextField.text!.isEmpty {
            sendButton.enabled = false
        } else {
            sendButton.enabled = true
        }
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
    
    func keyboardWillShow(notification: NSNotification) {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        enterTextViewBottomConstraint.constant = frame.height
    }
    
    func textFieldDidChange(textField: UITextField) {
        styleSendButton()
    }
    
    func takeToBottomOfTableView() {
        let chatEntriesCount = chatEntries?.count ?? 0
        if (chatEntriesCount > 0) {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: chatEntries!.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }    
    
    @IBAction func didSendButtonTap(sender: AnyObject) {
        let chatEntry = ChatEntry()
        chatEntry.chatText = enterChatTextField.text
        chatEntry.user = User.currentUser
        chatEntry.planId = self.plan.pfObject.objectId!
        chatEntry.chatTimeStamp = NSDate()
        
        chatEntry.saveToParseInBackground()
        
        self.chatEntries?.append(chatEntry)
        self.tableView.reloadData()
        
        enterTextViewBottomConstraint.constant = 0
        enterChatTextField.resignFirstResponder()
        enterChatTextField.text = nil
        
        takeToBottomOfTableView()        
    }
}
