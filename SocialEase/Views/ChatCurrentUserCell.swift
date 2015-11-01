//
//  ChatCurrentUserCell.swift
//  SocialEase
//
//  Created by Soumya on 10/31/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class ChatCurrentUserCell: UITableViewCell {
    @IBOutlet weak var chatText: UILabel!
    @IBOutlet weak var chatTimestamp: UILabel!
    @IBOutlet weak var textBackgroundView: UIView!
    
    var chatEntry: ChatEntry! {
        didSet {
            chatText.text = chatEntry.chatText!
            chatTimestamp.text = chatEntry.formattedTimeString()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        ViewTransformationUtils.roundEdges(textBackgroundView, cornerRadius: 5, borderColor: UIColor.clearColor(), borderWidth: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
