//
//  GroupSelectionViewController.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/17/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class GroupSelectionViewController: UIViewController {
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    var completionCallback: ((group: Group) -> ())?
    
    var groups = [Group]() {
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
        
        Group.groupsForCurrentUser() { (groups: [Group]?, error: NSError?) -> Void in
            if let groups = groups where error == nil {
                self.groups = groups
            }
        }
        
        // So view doesn't hide behind navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    func onNewGroupTap() {
        let viewController = GroupCreateViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextAction(group: Group) {
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
