//
//  ChatFriendCell.swift
//  SocialEase
//
//  Created by Soumya on 10/31/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class ChatFriendCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var chatText: UILabel!
    @IBOutlet weak var chatTimestamp: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var chatEntry: ChatEntry! {
        didSet {
            userName.text = chatEntry.user.name!
            chatText.text = chatEntry.chatText!
            chatTimestamp.text = chatEntry.formattedTimeString()
            userImageView.setImageWithURL(chatEntry.user.profileImageUrl!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        ViewTransformationUtils.roundEdges(userImageView, cornerRadius: 5, borderColor: UIColor.clearColor(), borderWidth: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
