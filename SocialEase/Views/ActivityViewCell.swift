//
//  ActivityViewCell.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/26/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import MapKit

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
    @IBOutlet weak var activityMapViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityDetailsViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!

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
        static let UnselectedLikeButtonBgkColor = UIColor(red: 0, green: 128/255, blue: 0, alpha: 0.5)
        static let SelectedDislikeButtonBgkColor = UIColor(red: 1, green: 102/255, blue: 102/255, alpha: 0.9)
        static let UnselectedDislikeButtonBgkColor = UIColor(red: 1, green: 102/255, blue: 102/255, alpha: 0.5)
    }

    var mapViewShowing = false
    var originalDetailsCenterConstraint: CGFloat!
    var originalMapCenterConstraint: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityImageView.contentMode = .ScaleAspectFill
        activityImageView.clipsToBounds = true
        ViewTransformationUtils.convertViewToCircle(activityImageView, borderColor: UIColor.whiteColor(), borderWidth: 5)
        ViewTransformationUtils.convertViewToCircle(dislikeButton, borderColor: UIColor.whiteColor(), borderWidth: 0)
        ViewTransformationUtils.convertViewToCircle(likeButton, borderColor: UIColor.whiteColor(), borderWidth: 0)
        activityLocationMapView.scrollEnabled = false

        // set initial offset
        activityMapViewCenterConstraint.constant = 0.5 * self.bounds.width + 0.5 * self.activityLocationMapView.bounds.width

        // add ui gesture
        let detailsPanGesture = UIPanGestureRecognizer(target: self, action: "snippentViewPanned:")
        detailsContainerView.addGestureRecognizer(detailsPanGesture)

        let mapPanGesture = UIPanGestureRecognizer(target: self, action: "snippentViewPanned:")
        activityLocationMapView.addGestureRecognizer(mapPanGesture)
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Actions methods
    func snippentViewPanned(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(contentView)
        let velocity = sender.velocityInView(contentView)

        if sender.state == UIGestureRecognizerState.Began {
            originalDetailsCenterConstraint = activityDetailsViewCenterConstraint.constant
            originalMapCenterConstraint = activityMapViewCenterConstraint.constant
        } else if sender.state == UIGestureRecognizerState.Changed {
            activityDetailsViewCenterConstraint.constant = originalDetailsCenterConstraint + translation.x
            activityMapViewCenterConstraint.constant = originalMapCenterConstraint + translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.2) {
                self.activityDetailsViewCenterConstraint.constant = velocity.x > 0 ? 0 : -0.5 * self.bounds.width - 0.5 * self.activityInfoContainerView.bounds.width
                self.activityMapViewCenterConstraint.constant = velocity.x > 0 ? 0.5 * self.bounds.width + 0.5 * self.activityLocationMapView.bounds.width : 0
                self.pageControl.currentPage = velocity.x > 0 ? 0 : 1
                self.layoutIfNeeded()
            }
        }
    }

    @IBAction func likeButtonTapped(sender: UIButton) {
        let vote = UserActivityVote.Like != usrActivity.vote ? UserActivityVote.Like : UserActivityVote.None
        delegate?.activityViewCell(self, didUpdateActivityVoteToVote: vote, atIndexPath: cellIndexPath)
    }

    @IBAction func dislikeButtonTapped(sender: UIButton) {
        let vote = UserActivityVote.Dislike != usrActivity.vote ? UserActivityVote.Dislike : UserActivityVote.None
        delegate?.activityViewCell(self, didUpdateActivityVoteToVote: vote, atIndexPath: cellIndexPath)
    }

    // MARK: - Helper methods
    private func updateCellView() {
        activityNameLabel?.text = usrActivity.activity?.name!
        activityLocationLabel?.text = "\((usrActivity.activity?.city!)!), \((usrActivity.activity?.state!)!)"
        usrActivity.activity?.setImageOnUIImageView(activityImageView)
        if let rating = usrActivity.activity?.rating {
            activityRatingsLabel.text = AppUtilities.getRatingsTextFromRating(rating)
        }
        activityDetailsLabel.text = usrActivity.activity?.details

        switch usrActivity.vote {
        case .Like:
            likeButton.backgroundColor = CellConstants.SelectedLikeButtonBgkColor
            dislikeButton.backgroundColor = CellConstants.UnselectedDislikeButtonBgkColor
        case .Dislike:
            likeButton.backgroundColor = CellConstants.UnselectedLikeButtonBgkColor
            dislikeButton.backgroundColor = CellConstants.SelectedDislikeButtonBgkColor
        case .None:
            likeButton.backgroundColor = CellConstants.UnselectedLikeButtonBgkColor
            dislikeButton.backgroundColor = CellConstants.UnselectedDislikeButtonBgkColor
        }
    }

    private func updateMapViewAnnotation() {
        if let activity = usrActivity.activity {
            let annotation = MKPointAnnotation()
            annotation.coordinate = activity.coordinate
            activityLocationMapView.showAnnotations([annotation], animated: false)
        }
    }
}
