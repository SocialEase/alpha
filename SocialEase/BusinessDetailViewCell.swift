//
//  BusinessDetailViewCell.swift
//  SocialEase
//
//  Created by Mo, Kevin on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class BusinessDetailViewCell: UITableViewCell {

    @IBOutlet weak var businessImageView: UIImageView!
    
    @IBOutlet weak var businessNameLabel: UILabel!
    
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    
    var activity: SEAActivity! {
        didSet {
            updateBusinessDetailsInCell()
        }
    }
    
    func updateBusinessDetailsInCell() {
        businessImageView.contentMode = .ScaleToFill
        businessNameLabel.text = activity.name
        businessImageView.setImageWithURL(activity.posterImageUrl!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
