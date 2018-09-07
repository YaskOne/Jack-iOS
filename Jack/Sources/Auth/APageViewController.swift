//
//  APageViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 8/7/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

protocol APageViewControllerDelegate {
    func pageChanged(index: Int)
}

class APageViewController: UIPageViewController {
    
    public lazy var pages: [UIViewController] = {
        return [UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EmailPageViewController"),
                UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "PasswordPageViewController"),
                UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "FinishedPageViewController")]
    }()
    
    var pageDelegate: APageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    func setUp() {
        dataSource = self

        if let firstViewController = pages.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    func indexOfController(_ viewController: UIViewController) -> Int? {
        return pages.index(of: viewController)
    }

}

extension APageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = indexOfController(viewController), index - 1 >= 0 else {
            return nil
        }
        
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = indexOfController(viewController), index + 1 < pages.count else {
            return nil
        }
        
        return pages[index + 1]
    }
    
}
