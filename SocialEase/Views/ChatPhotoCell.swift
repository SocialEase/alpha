//
//  ChatPhotoCell.swift
//  SocialEase
//
//  Created by Soumya on 11/1/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse

class ChatPhotoCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var chatTimestamp: UILabel!
    
    var chatEntry: ChatEntry! {
        didSet {
            userName.text = chatEntry.user.name!
            chatTimestamp.text = chatEntry.formattedTimeString()
            userImageView.setImageWithURL(chatEntry.user.profileImageUrl!)
            
            if let imageFile = chatEntry.imagePFFile {
                imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if let imageData = imageData {
                        self.chatImageView.image = UIImage(data: imageData)
                        self.chatImageView.contentMode = UIViewContentMode.ScaleAspectFill;
                    }
                }
            }            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ViewTransformationUtils.roundEdges(userImageView, cornerRadius: 5, borderColor: UIColor.clearColor(), borderWidth: 1)
        ViewTransformationUtils.roundEdges(chatImageView, cornerRadius: 5, borderColor: UIColor.clearColor(), borderWidth: 1)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
