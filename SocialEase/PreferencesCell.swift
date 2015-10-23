//
//  PreferencesCell.swift
//  SocialEase
//
//  Created by Uday on 10/22/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class PreferencesCell: UITableViewCell {

    @IBOutlet weak var preferenceString: UILabel!
    @IBOutlet weak var selectedStateLabel: UILabel!
    
    var preference : OtherPreference! {
        didSet {
            preferenceString.text = preference.displayString
            setSelectedState()            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        styleView()
    }

    func styleView() {
        preferenceString.textColor = UIColor.sea_primaryLabelColor()
        selectedStateLabel.textColor = UIColor.sea_primaryLabelColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSelectedState() {
        if (preference.isSelected) {
            selectedStateLabel.textColor = UIColor.sea_primaryHighlightColor()
            selectedStateLabel.text = "d"
        } else {
            selectedStateLabel.textColor = UIColor.sea_primaryLabelColor()
            selectedStateLabel.text = "e"
        }
    }
}
