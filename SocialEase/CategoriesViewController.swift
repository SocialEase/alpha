//
//  CategoriesViewController.swift
//  SocialEase
//
//  Created by Uday on 10/18/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    static var completionCallback: (() -> ())?
    
    var cuisines: [Cuisine]?
    @IBOutlet weak var cuisinesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Cuisine.getCuisines { (cuisines, error) -> () in
            if (error == nil) {
                self.cuisines = cuisines
                self.cuisinesCollectionView.reloadData()
            }
        }
        
        cuisinesCollectionView.delegate = self
        cuisinesCollectionView.dataSource = self
        // more auto sizing
        
        // not showing the preferences info modal anymore
        // performSegueWithIdentifier("preferencesInfoModal", sender: self)
    }
    
    override func viewDidLayoutSubviews() {
        self.styleView()
    }
    
    func styleView() {
        view.backgroundColor = UIColor.whiteColor()
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cuisines?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = cuisinesCollectionView.dequeueReusableCellWithReuseIdentifier("CuisineCell", forIndexPath: indexPath) as! CuisineCell
        cell.cellSelected = false
        
        cell.cuisine = cuisines![indexPath.row]
        return cell
    }
    
    @IBAction func didNextScreenTap(sender: AnyObject) {
        var favoriteCuisines = [String]()
        for cuisine in cuisines! {
            if (cuisine.userSelected) {
                favoriteCuisines.append(cuisine.cuisineName)
            }
        }
        
        let userPreferences = UserPreferences(favoriteCuisines: favoriteCuisines)
        User.currentUser?.userPreferences = userPreferences
        openGroupsController()
    }
    
    func openGroupsController() {
        performSegueWithIdentifier("otherPreferencesViewSegue", sender: self)
    }
    
    func nextAction() {
        if let completionCallback = CategoriesViewController.completionCallback {
            completionCallback()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
