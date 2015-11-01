//
//  OtherPreferencesViewController.swift
//  SocialEase
//
//  Created by Uday on 10/22/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class OtherPreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var preferences = OtherPreference.getAllPreferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableViewAutomaticDimension
        
        styleView()
    }

    func styleView() {
        view.backgroundColor = UIColor.sea_primaryBackgroundColor()
        tableView.backgroundColor = UIColor.sea_primaryBackgroundColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return preferences.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return preferences[section].0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let prefs = preferences[section].1
        return prefs.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PreferencesCell", forIndexPath: indexPath) as! PreferencesCell
        let pref = preferences[indexPath.section].1[indexPath.row]
        cell.preference = pref
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        for preference in preferences[indexPath.section].1 {
            preference.isSelected = false
        }
        preferences[indexPath.section].1[indexPath.row].isSelected = true
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
    }
    
    
    @IBAction func onNextTap(sender: AnyObject) {
        let appFlow = AppFlow()
        appFlow.presentHomePageViewController()
    }
}
