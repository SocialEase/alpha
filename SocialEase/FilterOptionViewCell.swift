//
//  FilterOptionViewCell.swift
//  SocialEaseSuggestionsWorkflow
//
//  Created by Amay Singhal on 10/18/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit

class FilterOptionViewCell: UITableViewCell {

    @IBOutlet weak var filterSelectedStateLabel: UILabel!
    @IBOutlet weak var filterOptionNameLabel: UILabel!

    static let Identifier = "FilterOptionViewCell"
    static let EstimateRowHeight: CGFloat = 51

    var filter: SuggestionsFilter! {
        didSet {
            updateCellView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateCellView() {
        filterSelectedStateLabel.text = filter.isSelected ? String(SocialEaseIconsType.FilledCircle.rawValue) : String(SocialEaseIconsType.EmptyCircle.rawValue)
        filterSelectedStateLabel.textColor = filter.isSelected ? UIColor(red: 255/255, green: 153/255, blue: 90/255, alpha: 1) : UIColor.darkGrayColor()
        filterOptionNameLabel.text = filter.displayName
    }
}
