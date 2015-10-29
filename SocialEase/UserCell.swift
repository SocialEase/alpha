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
    
    var cellSelected = false
    
    var user: User! {
        didSet {
            if let firstName = user.name, lastInitial = user.lastName?.characters.first {
                nameLabel.text = firstName + " " + String(lastInitial) + "."
            } else if let firstName = user.name {
                nameLabel.text = firstName
            }
            
            if let imageUrl = user.profileImageUrl {
                imageView.setImageWithURL(imageUrl)
            } else if let imageBinName = user.profileImageBinName {
                imageView.image = UIImage(named: imageBinName)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.textColor = UIColor.sea_secondaryHintColor()
        nameLabel.font = UIFont.boldSystemFontOfSize(17)
        
        ViewTransformationUtils.convertViewToCircle(imageView, borderColor: UIColor.sea_primaryLabelColor(), borderWidth: 1)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        let imageTap = UITapGestureRecognizer(target: self, action: "onImageTap:")
        imageTap.numberOfTapsRequired = 1
        overlayView.addGestureRecognizer(imageTap)
        overlayView.layer.cornerRadius = imageView.layer.frame.width / 2
        overlayView.layer.masksToBounds = true
    }
    
    func onImageTap(gestureRecognizer: UITapGestureRecognizer) {
        cellSelected = !cellSelected
        showTappedStateForCell()
    }
    
    func showTappedStateForCell() {
        let endColor = cellSelected ? UIColor.sea_secondarySelectedColor() : UIColor.clearColor()

        if let delegate = delegate {
            if cellSelected {
                delegate.userSelected(user)
            } else {
                delegate.userDeselected(user)
            }
        }
        
        UIView.animateWithDuration(0.15, animations: {
            self.overlayView.backgroundColor = endColor
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
