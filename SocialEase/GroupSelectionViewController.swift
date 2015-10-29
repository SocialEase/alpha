//
//  GroupSelectionViewController.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/17/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import JTProgressHUD
import Parse

class GroupSelectionViewController: UIViewController {
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    var completionCallback: ((group: UserGroup) -> ())?
    
    var groups = [UserGroup]() {
        didSet {
            groupsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = "Select Group"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Group", style: UIBarButtonItemStyle.Plain, target: self, action: "onNewGroupTap")
        
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        groupsTableView.registerNib(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        groupsTableView.rowHeight = UITableViewAutomaticDimension
        groupsTableView.estimatedRowHeight = 140

        // So view doesn't hide behind navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    override func viewWillAppear(animated: Bool) {
        JTProgressHUD.show()
        UserGroupUser.fetchGroupAndGroupUsersForUser(PFUser.currentUser()!) { (usergroups: [UserGroup]?, error: NSError?) -> () in
            JTProgressHUD.hide()
            if let usergroups = usergroups {
                self.groups = usergroups
            }
        }
    }
    
    func onNewGroupTap() {
        let viewController = GroupCreateViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextAction(group: UserGroup) {
        if let completionCallback = self.completionCallback {
            completionCallback(group: group)
        }
    }
    
}

extension GroupSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = groupsTableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as! GroupCell
        
        cell.group = groups[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        nextAction(groups[indexPath.row])
    }
}
