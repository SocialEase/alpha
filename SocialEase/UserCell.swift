//
//  UserCell.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

protocol UserCellDelegate: class {
    func userSelected(user: User)
    func userDeselected(user: User)
}

class UserCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    
    weak var delegate: UserCellDelegate?
    
    let (unselectedBorderColor, selectedBorderColor) = (UIColor.sea_primaryLabelColor(), UIColor.sea_primaryColor())
    let (unselectedOverlayColor, selectedOverlayColor) = (UIColor.sea_primaryLightTextColor(), UIColor.clearColor())
    let (unselectedLabelColor, selectedLabelColor) = (UIColor.sea_primaryLabelColor(), UIColor.sea_primaryColor())
    let (unselectedBorderWidth, selectedBorderWidth) = (1, 10)
    
    var cellSelected = false
    
    var user: User! {
        didSet {
            if let firstName = user.name, lastInitial = user.lastName?.characters.first {
                nameLabel.text = firstName + " " + String(lastInitial) + "."
            } else if let firstName = user.name {
                nameLabel.text = firstName
            }
            
            if let imageUrl = user.profileImageUrl {
                imageView.setImageWithURLRequest(NSURLRequest(URL: imageUrl), placeholderImage: UIImage(named: "default-user-profile"), fadeInWithDuration: 0.5)
            } else if let imageBinName = user.profileImageBinName {
                imageView.image = UIImage(named: imageBinName)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.textColor = unselectedLabelColor
        nameLabel.font = UIFont.boldSystemFontOfSize(17)
        
        ViewTransformationUtils.convertViewToCircle(imageView, borderColor: unselectedBorderColor, borderWidth: unselectedBorderWidth)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        let imageTap = UITapGestureRecognizer(target: self, action: "onImageTap:")
        imageTap.numberOfTapsRequired = 1
        overlayView.addGestureRecognizer(imageTap)
        overlayView.alpha = 0.25
        overlayView.layer.cornerRadius = imageView.layer.frame.width / 2
        overlayView.layer.masksToBounds = true
        overlayView.backgroundColor = unselectedOverlayColor
    }
    
    func onImageTap(gestureRecognizer: UITapGestureRecognizer) {
        cellSelected = !cellSelected
        showTappedStateForCell()
    }
    
    func showTappedStateForCell() {
        let endOverlayColor = cellSelected ? selectedOverlayColor : unselectedOverlayColor
        let endBorderColor = cellSelected ? selectedBorderColor : unselectedBorderColor
        let endBorderWidth = cellSelected ? selectedBorderWidth : unselectedBorderWidth
        let endLabelColor = cellSelected ? selectedLabelColor : unselectedLabelColor

        if let delegate = delegate {
            if cellSelected {
                delegate.userSelected(user)
            } else {
                delegate.userDeselected(user)
            }
        }
        
        UIView.animateWithDuration(0.15, animations: {
            self.overlayView.backgroundColor = endOverlayColor
            self.nameLabel.textColor = endLabelColor
            self.imageView.layer.borderColor = endBorderColor.CGColor
            self.imageView.layer.borderWidth = CGFloat(endBorderWidth)
            self.imageView.transform = CGAffineTransformMakeScale(0.75, 0.75)
            self.overlayView.transform = CGAffineTransformMakeScale(0.75, 0.75)
            }, completion: { (finished) in
                UIView.animateWithDuration(0.15, animations: {
                    self.imageView.transform = CGAffineTransformMakeScale(1, 1)
                    self.overlayView.transform = CGAffineTransformMakeScale(1, 1)
                })
        })
    }
    
}
