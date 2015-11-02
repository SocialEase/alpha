//
//  GroupCell.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import AFNetworking

class GroupCell: UITableViewCell {

    @IBOutlet weak var insetContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupCountLabel: UILabel!
    @IBOutlet weak var friendsContainerView: UIView!
    @IBOutlet weak var othersCountLabel: UILabel!
    
    let userImageDiameter = 45
    var userImageMaxShown = 5
    
    var userImageViews: [UIImageView]!
    
    var group: UserGroup! {
        didSet {
            if let name = group.name {
                nameLabel.text = name
            }
            groupCountLabel.text = "(\(group.pfUsers.count))"
            if group.pfUsers.count > userImageMaxShown {
                othersCountLabel.text = "\(group.pfUsers.count - userImageMaxShown) others..."
            } else {
                othersCountLabel.text = ""
            }
            
            // Reset when cell is reused.
            userImageViews = [UIImageView]()
            if let users  = group.users {
                for user in users {
                    // Create user image views with placeholder images
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: userImageDiameter, height: userImageDiameter))
                    let defaultImage = UIImage(named: "default-user-profile")

                    if let profileImageUrl = user.profileImageUrl {
                        imageView.setImageWithURLRequest(NSURLRequest(URL: profileImageUrl), placeholderImage: defaultImage, fadeInWithDuration: 0.5)
                    } else {
                        imageView.image = defaultImage
                    }

                    ViewTransformationUtils.convertViewToCircle(imageView, borderColor: UIColor.sea_primaryLabelColor(), borderWidth: 1)

                    imageView.contentMode = UIViewContentMode.ScaleAspectFill
                    userImageViews.append(imageView)

                    if userImageViews.count >= 5 {
                        break
                    }
                }
                loadImages()
            }

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.font = UIFont.boldSystemFontOfSize(17.0)
        nameLabel.textColor = UIColor.sea_primaryLabelColor()
        
        groupCountLabel.textColor = UIColor.sea_secondaryHintColor()
        
        //friendsContainerView.backgroundColor = UIColor.sea_primaryShadeColor()
        friendsContainerView.layer.cornerRadius = 10
        friendsContainerView.layer.masksToBounds = true
        
        othersCountLabel.font = UIFont.systemFontOfSize(13)
        othersCountLabel.textColor = UIColor.sea_secondaryHintColor()
        
        self.insetContainerView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.insetContainerView.layer.shadowOpacity = 0.7
        self.insetContainerView.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.insetContainerView.layer.shadowRadius = 2.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImages() {
        for (i, imageView) in userImageViews.enumerate() {
            friendsContainerView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            if i != 0 {
                friendsContainerView.addConstraint(NSLayoutConstraint(item: userImageViews[i], attribute: .Height, relatedBy: .Equal, toItem: userImageViews[i-1], attribute: .Height, multiplier: 1, constant: 0))
                friendsContainerView.addConstraint(NSLayoutConstraint(item: userImageViews[i], attribute: .Width, relatedBy: .Equal, toItem: userImageViews[i-1], attribute: .Width, multiplier: 1, constant: 0))
                friendsContainerView.addConstraint(NSLayoutConstraint(item: userImageViews[i], attribute: .Leading, relatedBy: .Equal, toItem: userImageViews[i-1], attribute: .Trailing, multiplier: 1, constant: 12))
                friendsContainerView.addConstraint(NSLayoutConstraint(item: userImageViews[i], attribute: .CenterY, relatedBy: .Equal, toItem: userImageViews[i-1], attribute: .CenterY, multiplier: 1, constant: 0))
            } else {
                // Set constraints for first image on the left
                friendsContainerView.addConstraint(NSLayoutConstraint(item: userImageViews[i], attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: CGFloat(userImageDiameter)))
                friendsContainerView.addConstraint(NSLayoutConstraint(item: userImageViews[i], attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: CGFloat(userImageDiameter)))
                friendsContainerView.addConstraint(NSLayoutConstraint(item: userImageViews[i], attribute: .CenterY, relatedBy: .Equal, toItem: userImageViews[i].superview, attribute: .CenterY, multiplier: 1, constant: 0))
                friendsContainerView.addConstraint(NSLayoutConstraint(item: userImageViews[i], attribute: .Leading, relatedBy: .Equal, toItem: userImageViews[i].superview, attribute: .Leading, multiplier: 1, constant: 12))
            }
        }
    }
    
}
