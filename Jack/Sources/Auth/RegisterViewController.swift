//
//  RegisterViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 8/7/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl?
//    @IBOutlet weak var containerView: UIView!
    
    var pageViewController: APageViewController? {
        didSet {
            pageViewController?.pageDelegate = self
            pageControl?.numberOfPages = (pageViewController?.pages.count)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl?.currentPage = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RegisterPageViewController" {
            if let pageController = segue.destination as? APageViewController {
                self.pageViewController = pageController
            }
        }
    }

}

extension RegisterViewController: APageViewControllerDelegate {
    func pageChanged(index: Int) {
        pageControl?.currentPage = index
    }
}
