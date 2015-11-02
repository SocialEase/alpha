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
    @IBOutlet weak var enterChatView: UIView!

    private var _plan: Plan!

    var plan: Plan {
        get {
            return _plan
        }
        set(newValue) {
            _plan = newValue
            updateChatsFromBackend()
        }
    }
    
    var chatEntries: [ChatEntry]? {
        didSet {
            onNewChats()
        }
    }
    
    var timer: NSTimer?
    
    // MARK: - Lifecylce methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterChatView.backgroundColor = UIColor.sea_primaryColor()
        styleSendButton()
        
        // table view setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // kick off timer to refresh chats periodically
        // TODO: use push notifications to get chats
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        
        // observer for keyboard pop
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        enterChatTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        onNewChats()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        onNewChats()
    }
    
    func updateChatsFromBackend() {
        ChatEntry.getChatEntriesForPlan(plan.pfObject.objectId!, usersInPlan: _plan.users!) { (chatEntries, error) -> () in
            if (chatEntries != nil) {
                self.chatEntries = chatEntries
            } else {
                print("Error getting chat entries for plan")
            }
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        // stop timer
        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }
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
        if let _ = chatEntry.imagePFFile {
            let cell = tableView.dequeueReusableCellWithIdentifier("ChatPhotoCell") as! ChatPhotoCell
            cell.chatEntry = chatEntry
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ChatFriendCell") as! ChatFriendCell
            cell.chatEntry = chatEntry
            return cell
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let rect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        enterTextViewBottomConstraint.constant = rect.height - self.navigationController!.navigationBar.frame.height
    }
    
    func textFieldDidChange(textField: UITextField) {
        styleSendButton()
    }
    
    func takeToBottomOfTableView() {
        let chatEntriesCount = chatEntries?.count ?? 0
        if (chatEntriesCount > 0) {
            tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: chatEntries!.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
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
        onNewChats()
        
        enterTextViewBottomConstraint.constant = 0
        enterChatTextField.resignFirstResponder()
        enterChatTextField.text = nil
        
        takeToBottomOfTableView()        
    }
    
    func onTimer() {
        updateChatsFromBackend()
    }
    
    func onNewChats() {
        self.tableView?.reloadData()
        takeToBottomOfTableView()
    }
}
