//
//  WalkthroughPageViewController.swift
//  AppFood
//  Onboarding
//  Created by MRGS on 18.06.2022.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController {
    
    var pageHeadings = ["CREATE YOUR OWN FOOD GUIDE",
                        "SHOW YOU THE LOCATION",
                        "DISCOVER GREAT RESTAURANTS"
    ]
    var pageImages = ["onboarding-1",
                      "onboarding-2",
                      "onboarding-3"
    ]
    var pageSubHeadings = ["Pin your favorite restaurants and create your own food guide",
                           "Search and locate your favourite restaurant on Maps",
                           "Find restaurants shared by your friends and other foodies"
    ]
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the data source to itself
            dataSource = self
            // Create the first walkthrough screen
            if let startingViewController = contentViewController(at: 0) {
                setViewControllers([startingViewController], direction: .forward,animated: true, completion: nil)
            }
    }
    
    
    
}
extension WalkthroughPageViewController: UIPageViewControllerDataSource {
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        // Create a new view controller and pass suitable data.
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    
    
}
