//
//  UserCell.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedCircle: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var isUserSelected = false
    
    var user: User! {
        didSet {
            /* TODO: Use this if we separate name into first + last.
            if let lastInitial = user.lastName.characters.first {
                nameLabel.text = user.firstName + " " + String(lastInitial) + "."
            } else {*/
                nameLabel.text = user.name
            //}
            if let imageBinName = user.profileImageBinName {
                imageView.image = UIImage(named: imageBinName)
            } else if let imageUrl = user.profileImageUrl {
                imageView.setImageWithURL(imageUrl)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.textColor = UIColor.sea_secondaryHintColor()
        nameLabel.font = UIFont.boldSystemFontOfSize(17)
        
        let imageTap = UITapGestureRecognizer(target: self, action: "onImageTap:")
        imageTap.numberOfTapsRequired = 1
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(imageTap)
        imageView.layer.cornerRadius = imageView.layer.frame.width / 2
        imageView.layer.masksToBounds = true
        
        // When the user image is 'selected', the circle gets displayed above the user image, and the
        // gesture for that stops responding, so another responder is required for the circle when 'unselected'
        let circleTap = UITapGestureRecognizer(target: self, action: "onCircleTap:")
        circleTap.numberOfTapsRequired = 1
        selectedCircle.userInteractionEnabled = true
        selectedCircle.addGestureRecognizer(circleTap)
        selectedCircle.backgroundColor = UIColor.clearColor()
        selectedCircle.layer.borderColor = UIColor.sea_secondarySelectedColor().CGColor
        selectedCircle.layer.borderWidth = 10.0
        selectedCircle.layer.cornerRadius = imageView.layer.cornerRadius
        selectedCircle.layer.masksToBounds = true
        selectedCircle.hidden = true
    }
    
    func onImageTap(gestureRecognizer: UITapGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Ended:
            selectedCircle.hidden = false
        default:
            break
        }
    }
    
    func onCircleTap(gestureRecognizer: UITapGestureRecognizer) {
        switch gestureRecognizer.state {
        case .Ended:
            selectedCircle.hidden = true
        default:
            break
        }
    }

    
}
