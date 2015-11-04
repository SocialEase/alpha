//
//  PlanPreviewCell.swift
//  SocialEase
//
//  Created by Uday on 10/25/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class PlanPreviewCell: UITableViewCell {
    @IBOutlet weak var planImageView: UIImageView!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var planTimeLabel: UILabel!
    
    @IBOutlet weak var userImageView1: UIImageView!
    @IBOutlet weak var userImageView2: UIImageView!
    @IBOutlet weak var userImageView3: UIImageView!
    
    @IBOutlet weak var maskOverPhotoView: UIView!
    
    var plan : Plan! {
        didSet {
            planNameLabel.text = plan.name!
            planTimeLabel.text = DateUtils.getDisplayDate(plan.occuranceDateTime!)

            planImageView.clipsToBounds = true
            planImageView.contentMode = .ScaleAspectFill
            plan.setImageOnUIImageView(planImageView)

            plan.getPlanUsersWithCompletion { (users: [User]?, error: NSError?) -> () in
                if let users = users {
                    self.usersInPlan = users
                }
            }
        }
    }
    
    var usersInPlan: [User]! {
        didSet {
            var profileImageUrls = [NSURL]()
            for user in usersInPlan {
                if let profileImageUrl = user.profileImageUrl {
                    profileImageUrls.append(profileImageUrl)
                }
            }
            
            if (profileImageUrls.count >= 1) {
                userImageView1.setImageWithURL(profileImageUrls[0])
                userImageView1.contentMode = .ScaleAspectFill
                ViewTransformationUtils.convertViewToCircle(userImageView1, borderColor: UIColor.whiteColor(), borderWidth: 1)
            }
            if (profileImageUrls.count >= 2) {
                userImageView2.setImageWithURL(profileImageUrls[1])
                userImageView2.contentMode = .ScaleAspectFill
                ViewTransformationUtils.convertViewToCircle(userImageView2, borderColor: UIColor.whiteColor(), borderWidth: 1)
            }
            if (profileImageUrls.count >= 3) {
                userImageView3.setImageWithURL(profileImageUrls[2])
                userImageView3.contentMode = .ScaleAspectFill
                ViewTransformationUtils.convertViewToCircle(userImageView3, borderColor: UIColor.whiteColor(), borderWidth: 1)
            }
        }
    }
    
    func styleCell() {
        planNameLabel.textColor = UIColor.sea_lightLabelColor()
        planTimeLabel.textColor = UIColor.sea_lightLabelColor()
        
        maskOverPhotoView.backgroundColor = UIColor.blackColor()
        maskOverPhotoView.alpha = 0.3
        
//        ViewTransformationUtils.addBlurToView(maskOverPhotoView, frame: planImageView.frame, style: UIBlurEffectStyle.Light)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
