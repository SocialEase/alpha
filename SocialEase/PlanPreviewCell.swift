//
//  PlanPreviewCell.swift
//  SocialEase
//
//  Created by Soumya on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class PlanPreviewCell: UITableViewCell {
    @IBOutlet weak var planImageView: UIImageView!
    @IBOutlet weak var planNameLabel: UILabel!
    @IBOutlet weak var planTimeLabel: UILabel!
    
    var plan : Plan! {
        didSet {
            planNameLabel.text = plan.name!
            planTimeLabel.text = plan.occuranceDateTime!.description
            plan.setImageOnUIImageView(planImageView)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
