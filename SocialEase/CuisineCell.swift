//
//  CuisineCell.swift
//  SocialEase
//
//  Created by Uday on 10/18/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit
import AFNetworking

class CuisineCell: UICollectionViewCell {
    @IBOutlet weak var cuisineImageView: UIImageView!
    @IBOutlet weak var cuisineNameLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var checkMarkLabel: UILabel!
    
    var cellSelected = false
    
    var cuisine: Cuisine! {
        didSet {
            cuisineNameLabel.text = cuisine.cuisineName
            cellSelected = cuisine.userSelected
            showTappedStateForCell()
            
            cuisineImageView.setImageWithURL(cuisine.imageUrl)
            cuisineImageView.contentMode = UIViewContentMode.ScaleToFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleView()
        
        let gesture = UITapGestureRecognizer(target: self, action: "cellTapped:")
        self.addGestureRecognizer(gesture)
    }
    
    func styleView() {
        cuisineNameLabel.textColor = UIColor.sea_primaryLabelColor()
        cuisineNameLabel.numberOfLines = 1;
        cuisineNameLabel.minimumScaleFactor = 0.2;
        cuisineNameLabel.adjustsFontSizeToFitWidth = true;
        
        checkMarkLabel.textColor = UIColor.sea_primaryColor()
        
        ViewTransformationUtils.convertViewToCircle(cuisineImageView, borderColor: UIColor.sea_primaryLabelColor(), borderWidth: 1)
        ViewTransformationUtils.convertViewToCircle(overlayView, borderColor: UIColor.sea_primaryLabelColor(), borderWidth: 1)
        
        showTappedStateForCell()
    }
    
    func cellTapped(sender: UITapGestureRecognizer) {
        cellSelected = !cellSelected
        cuisine.userSelected = cellSelected
        showTappedStateForCell()
    }
    
    func showTappedStateForCell() {
        let endColor = UIColor.clearColor()
        // cellSelected ? UIColor.sea_primaryColor() : UIColor.clearColor()
        let labelColor = cellSelected ? UIColor.sea_primaryColor() : UIColor.sea_primaryLabelColor()

        self.cuisineNameLabel.textColor = labelColor
        UIView.animateWithDuration(0.15, animations: {
            self.cuisineNameLabel.hidden = true
            self.overlayView.backgroundColor = endColor
            self.cuisineImageView.transform = CGAffineTransformMakeScale(0.75, 0.75)
            self.overlayView.transform = CGAffineTransformMakeScale(0.75, 0.75)
        }, completion: { (finished) in
            UIView.animateWithDuration(0.15, animations: {
                self.cuisineNameLabel.hidden = false
                self.cuisineImageView.transform = CGAffineTransformMakeScale(1, 1)
                self.overlayView.transform = CGAffineTransformMakeScale(1, 1)
                self.checkMarkLabel.hidden = !self.cellSelected
                })
        })
    }
}
