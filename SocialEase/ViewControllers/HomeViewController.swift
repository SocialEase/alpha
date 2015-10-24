//
//  HomePageViewController.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/23/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!

    var pageViewController: UIPageViewController!

    lazy var planDisplayViewControllerList: [DisplayPlanVC] = {
        var vcList = [DisplayPlanVC]()
        // add active plan view controller
        let activePlanVC = Storyboard.Home.instantiateViewControllerWithIdentifier(Storyboard.PlanDisplayVCIdentifier) as! PlanDisplayViewController
        let displayActivePlanContainer = DisplayActivePlansVC()
        displayActivePlanContainer.planDisplayVC = activePlanVC
        vcList.append(displayActivePlanContainer)

        // add pending plan view controller
        let pendingPlanVC = Storyboard.Home.instantiateViewControllerWithIdentifier(Storyboard.PlanDisplayVCIdentifier) as! PlanDisplayViewController
        let displayPendingPlanContainer = DisplayPendingPlansVC()
        displayPendingPlanContainer.planDisplayVC = pendingPlanVC
        vcList.append(displayPendingPlanContainer)

        return vcList
    }()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // create a container view
        setupPageViewController()
    }

    // MARK: - PageViewController datasource methods
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! PlanDisplayViewController
        var index = viewController.pageIndex as Int

        if index == 0 || index == NSNotFound {
            return nil
        }

        return planDisplayViewControllerList[--index].planDisplayVC
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! PlanDisplayViewController
        var index = viewController.pageIndex as Int

        if index == NSNotFound || ++index == planDisplayViewControllerList.count {
            return nil
        }

        return planDisplayViewControllerList[index].planDisplayVC
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return planDisplayViewControllerList.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    // MARK: PageViewController delegate methods
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vc = previousViewControllers.first as? PlanDisplayViewController {
            if completed {
                let currentIndex = vc.pageIndex == 0 ? 1 : 0
                pageTitle.text = planDisplayViewControllerList[currentIndex].title
                pageControl.currentPage = currentIndex
            }
        }
    }

    // MARK: - View Actions
    @IBAction func preferenceButtonTapped(sender: UIButton) {

    }

    @IBAction func addNewPlanButtonTapped(sender: UIButton) {

    }

    // MARK: - Helper methods
    private func setupPageViewController() {

        // start setting up page view controller
        pageViewController = Storyboard.Home.instantiateViewControllerWithIdentifier(Storyboard.HomePageVCIdentifier) as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self

        pageViewController.setViewControllers([planDisplayViewControllerList[0].planDisplayVC], direction: .Forward, animated: true, completion: nil)
        pageViewController.view.frame = CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-25)
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)

    }

    private func planViewControllerAtIndex(index: Int) -> PlanDisplayViewController? {
        if index < planDisplayViewControllerList.count {
            return planDisplayViewControllerList[index].planDisplayVC
        }

        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
