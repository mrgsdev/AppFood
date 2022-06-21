//
//  WalkthroughViewController.swift
//  AppFood
//
//  Created by MRGS on 18.06.2022.
//

import UIKit

class WalkthroughViewController: UIViewController {
    var walkthroughPageViewController: WalkthroughPageViewController?
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    @IBOutlet var skipButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewController?.forwardPage()
            case 2:
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            }
        }
        updateUI()
        
    }
    
}
extension WalkthroughViewController{
    @IBAction func skipButtonTapped(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle(String(localized:"NEXT"), for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle(String(localized:"GET STARTED"), for: .normal)
                skipButton.isHidden = true
            default: break
            }
            pageControl.currentPage = index
        }
    }
}
extension WalkthroughViewController: WalkthroughPageViewControllerDelegate
{
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}
