//
//  GroupCreateViewController.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import JTProgressHUD

class GroupCreateViewController: UIViewController {
    
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    
    var selectedFriends = [User]()
    
    var friends = [User]() {
        didSet {
            friendsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: "onCreate")
        // Create button enabled when at least one user is selected.
        navigationItem.rightBarButtonItem?.enabled = false
        
        // Do any additional setup after loading the view.
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 120, height: 150)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        friendsCollectionView.backgroundColor = UIColor.sea_primaryBackgroundColor()
        friendsCollectionView.collectionViewLayout = flowLayout
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        friendsCollectionView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellWithReuseIdentifier: "UserCell")
        
        if let currentUser = User.currentUser {
            if let userId = currentUser.id {
                JTProgressHUD.show()
                User.friendsForUser(userId) { (friends: [User]?, error: NSError?) -> Void in
                    JTProgressHUD.hide()
                    
                    if let friends = friends where error == nil {
                        self.friends = friends
                    }
                }
            }
        }
        
    }
    
    func onCancel() {
        
    }
    
    func onCreate() {
        // Prompt form for new group name and add it to list of groups
        let alertController = UIAlertController(title: "New Group Name", message: "", preferredStyle: .Alert)
        
        let createAction = UIAlertAction(title: "Create", style: .Default) { (_) in
            let groupNameTextField = alertController.textFields![0] as UITextField
            
            // Add group
            if let groupName = groupNameTextField.text {
                self.createGroup(groupName)
            }
        }
        createAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Group Name"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                createAction.enabled = textField.text != ""
            }
        }
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func createGroup(groupName: String) {
        
        JTProgressHUD.show()
        Group.createNewGroup(groupName, users: selectedFriends) { (error: NSError?) -> Void in
            JTProgressHUD.hide()
            if error != nil {
                // TODO: Display error
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension GroupCreateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = friendsCollectionView.dequeueReusableCellWithReuseIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        
        cell.user = friends[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
}

extension GroupCreateViewController: UserCellDelegate {
    func userSelected(user: User) {
        //print("Friend add: " + user.name!)
        selectedFriends.append(user)
        
        if selectedFriends.count > 0 {
            navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    func userDeselected(user: User) {
        if selectedFriends.contains(user) {
            //print("Friend removed: " + user.name!)
            if let index = selectedFriends.indexOf(user) {
                selectedFriends.removeAtIndex(index)
            }
        }
        
        if selectedFriends.count <= 0 {
            navigationItem.rightBarButtonItem?.enabled = false
        }
    }
}
