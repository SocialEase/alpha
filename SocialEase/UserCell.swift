//
//  UserCell.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    
    var cellSelected = false
    
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
        
        imageView.layer.cornerRadius = imageView.layer.frame.width / 2
        imageView.layer.masksToBounds = true
        
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
