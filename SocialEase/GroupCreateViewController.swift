//
//  GroupCreateViewController.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class GroupCreateViewController: UIViewController {
    
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    
    var friends = [User]() {
        didSet {
            friendsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: "onCreate")
        
        // Do any additional setup after loading the view.
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 120, height: 150)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        friendsCollectionView.backgroundColor = UIColor.sea_primaryBackgroundColor()
        friendsCollectionView.collectionViewLayout = flowLayout
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        friendsCollectionView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellWithReuseIdentifier: "UserCell")
        
        User.friendsForCurrentUser() { (friends: [User]?, error: NSError?) -> Void in
            if let friends = friends where error == nil {
                self.friends = friends
            }
        }   
    }
    
    func onCancel() {
        
    }
    
    func onCreate() {
        // TODO: Prompt for new group name and add it to list of groups
        navigationController?.popViewControllerAnimated(true)
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
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
}
