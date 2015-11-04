//
//  ActivityViewCell.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/26/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import MapKit

enum ActivityCellPageViews: Int {
    case Details = 0, Map
}


protocol ActivityViewCellDelegate: class {
    func activityViewCell(activityViewCell: UITableViewCell, didUpdateActivityVoteToVote vote: UserActivityVote, atIndexPath indexpath: NSIndexPath)
}

class ActivityViewCell: UITableViewCell {

    static let EstimatedRowHeight: CGFloat = 150

    @IBOutlet weak var activityLocationMapView: MKMapView!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityLocationLabel: UILabel!
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var cellHeaderView: UIView!
    @IBOutlet weak var activityRatingsLabel: UILabel!
    @IBOutlet weak var activityDetailsLabel: UILabel!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var activityInfoContainerView: UIView!
    @IBOutlet weak var activityDetailsViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsContainerView: UIView!

    var cellIndexPath: NSIndexPath!

    weak var delegate: ActivityViewCellDelegate?

    var usrActivity: UserActivity! {
        didSet {
            updateCellView()
            updateMapViewAnnotation()
        }
    }

    struct CellConstants {
        static let SelectedLikeButtonBgkColor = UIColor(red: 0, green: 128/255, blue: 0, alpha: 0.9)
        static let UnselectedLikeButtonBgkColor = UIColor(red: 0, green: 128/255, blue: 0, alpha: 0.7)
        static let SelectedDislikeButtonBgkColor = UIColor(red: 187/255, green: 26/255, blue: 0/255, alpha: 0.9)
        static let UnselectedDislikeButtonBgkColor = UIColor(red: 187/255, green: 26/255, blue: 0/255, alpha: 0.7)
        static let SelectedButtonBorderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        static let UnselectedButtonBorderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)

        static let CenterConstraintDeltaScale: CGFloat = 0.5
    }

    var mapViewShowing = false
    var originalDetailsCenterConstraint: CGFloat!
    var originalMapCenterConstraint: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityImageView.contentMode = .ScaleAspectFill
        activityImageView.clipsToBounds = true
        ViewTransformationUtils.convertViewToCircle(dislikeButton, borderColor: UIColor.whiteColor(), borderWidth: 0)
        ViewTransformationUtils.convertViewToCircle(likeButton, borderColor: UIColor.whiteColor(), borderWidth: 0)
        activityLocationMapView.scrollEnabled = false

        // add gradient
        activityImageView.layer.addSublayer(getGradientForCellForView(activityImageView))
        activityLocationMapView.layer.addSublayer(getGradientForCellForView(activityLocationMapView))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Actions methods

    @IBAction func likeButtonTapped(sender: UIButton) {
        let vote = UserActivityVote.Like != usrActivity.vote ? UserActivityVote.Like : UserActivityVote.None
        delegate?.activityViewCell(self, didUpdateActivityVoteToVote: vote, atIndexPath: cellIndexPath)
    }

    @IBAction func dislikeButtonTapped(sender: UIButton) {
        let vote = UserActivityVote.Dislike != usrActivity.vote ? UserActivityVote.Dislike : UserActivityVote.None
        delegate?.activityViewCell(self, didUpdateActivityVoteToVote: vote, atIndexPath: cellIndexPath)
    }

    @IBAction func mapButtonTouchBegin(sender: UIButton) {
        activityImageView.alpha = 0
    }

    @IBAction func mapButtonTouchEnd(sender: UIButton) {
        activityImageView.alpha = 1
    }

    // MARK: - Helper methods
    private func updateCellView() {
        activityNameLabel?.text = usrActivity.activity?.name!
        activityLocationLabel?.text = usrActivity.activity?.getStateAndCityString()
        usrActivity.activity?.setImageOnUIImageView(activityImageView)
        if let rating = usrActivity.activity?.rating {
            activityRatingsLabel.text = AppUtilities.getRatingsTextFromRating(rating)
        }
        activityDetailsLabel.text = usrActivity.activity?.details

        switch usrActivity.vote {
        case .Like:
            likeButton.backgroundColor = CellConstants.SelectedLikeButtonBgkColor
            likeButton.layer.borderColor = CellConstants.SelectedButtonBorderColor.CGColor
            dislikeButton.backgroundColor = CellConstants.UnselectedDislikeButtonBgkColor
            dislikeButton.layer.borderColor = CellConstants.UnselectedButtonBorderColor.CGColor
        case .Dislike:
            likeButton.backgroundColor = CellConstants.UnselectedLikeButtonBgkColor
            likeButton.layer.borderColor = CellConstants.UnselectedButtonBorderColor.CGColor
            dislikeButton.backgroundColor = CellConstants.SelectedDislikeButtonBgkColor
            dislikeButton.layer.borderColor = CellConstants.SelectedButtonBorderColor.CGColor
        case .None:
            likeButton.backgroundColor = CellConstants.UnselectedLikeButtonBgkColor
            likeButton.layer.borderColor = CellConstants.UnselectedButtonBorderColor.CGColor
            dislikeButton.backgroundColor = CellConstants.UnselectedDislikeButtonBgkColor
            dislikeButton.layer.borderColor = CellConstants.UnselectedButtonBorderColor.CGColor
        }
    }

    private func updateMapViewAnnotation() {
        if let activity = usrActivity.activity {
            let annotation = MKPointAnnotation()
            annotation.coordinate = activity.coordinate
            activityLocationMapView.showAnnotations([annotation], animated: false)
        }
    }

    private func getGradientForCellForView(view: UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds

        // set colors
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor as CGColorRef
        let color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]

        // set range
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }
}
