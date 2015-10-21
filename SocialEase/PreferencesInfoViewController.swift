//
//  PreferencesInfoViewController.swift
//  SocialEase
//
//  Created by Uday on 10/18/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class PreferencesInfoViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapOnViewGesture = UITapGestureRecognizer.init(target: self, action: "didTapOnView:")
        self.view.addGestureRecognizer(tapOnViewGesture)
    }

    func styleView() {
        self.view.backgroundColor = UIColor.sea_primaryColor()
        infoLabel.textColor = UIColor.sea_primaryLabelColor()
    }
    
    override func viewDidLayoutSubviews() {
        self.styleView()
    }
    
    func didTapOnView(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
