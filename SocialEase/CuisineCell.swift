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
        cuisineNameLabel.minimumScaleFactor = 11;
        cuisineNameLabel.adjustsFontSizeToFitWidth = true;
        
        convertViewToCircle(cuisineImageView, borderColor: UIColor.sea_primaryLabelColor(), borderWidth: 1)
        convertViewToCircle(overlayView, borderColor: UIColor.sea_primaryLabelColor(), borderWidth: 1)
        
        showTappedStateForCell()

    }

    func convertViewToCircle(myView: UIView, borderColor: UIColor, borderWidth: Int) {
        myView.layer.masksToBounds = false
        myView.layer.cornerRadius = myView.frame.size.height/2
        myView.clipsToBounds = true

        myView.layer.borderWidth = 1.0
        myView.layer.borderColor = borderColor.CGColor
    }
    
    func cellTapped(sender: UITapGestureRecognizer) {
        cellSelected = !cellSelected
        cuisine.userSelected = cellSelected
        showTappedStateForCell()
    }
    
    func showTappedStateForCell() {
        let endColor = cellSelected ? UIColor.sea_primaryColor() : UIColor.whiteColor()

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
                })
        })
    }
}
