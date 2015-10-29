//
//  BusinessAddressTableViewCell.swift
//  SocialEase
//
//  Created by Mo, Kevin on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class BusinessAddressTableViewCell: UITableViewCell {
    
    var businessAddress: String! {
        didSet {
            addressLabel.text = businessAddress
        }
    }

    @IBOutlet weak var addressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
