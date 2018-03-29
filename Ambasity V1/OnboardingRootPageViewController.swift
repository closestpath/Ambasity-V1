//
//  OnboardingRootPageViewController.swift
//  Ambasity V1
//
//  Created by Zak on 3/29/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

class OnboardingRootPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var onboardingViewControllerList: [UIViewController] = {
        
        // Creating an array of the three onboarding view controllers with zero-indexing.
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboarding0 = storyboard.instantiateViewController(withIdentifier: "Onboarding0")
        let onboarding1 = storyboard.instantiateViewController(withIdentifier: "Onboarding1")
        let onboarding2 = storyboard.instantiateViewController(withIdentifier: "Onboarding2")
        
        return [onboarding0, onboarding1, onboarding2]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        
        if let firstOnboardingViewController = onboardingViewControllerList.first {
            self.setViewControllers([firstOnboardingViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = onboardingViewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard onboardingViewControllerList.count > previousIndex else {return nil}
        
        return onboardingViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = onboardingViewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = currentIndex + 1
        
        guard onboardingViewControllerList.count != nextIndex else {return nil}
        
        guard onboardingViewControllerList.count > nextIndex else {return nil}
        
        return onboardingViewControllerList[nextIndex]
    }
}
