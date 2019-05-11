//
//  MyViewPagerViewController.swift
//  Example-Swift
//
//  Created by samuel on 2019/4/6.
//  Copyright © 2019 samuel. All rights reserved.
//

import UIKit

class MyViewPagerViewController: SegmentedPagerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView = UIView()
        self.headerView.backgroundColor = .blue
        
        let segmentedControl = UISegmentedControl(items: ["segment0", "segment1", "segment2", "segment3"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        self.segmentedControl = segmentedControl
        self.tabStripHeight = 32
    }
    
    @objc private func segmentAction(_ sender: UISegmentedControl) {
        viewPager.moveToViewController(at: sender.selectedSegmentIndex, animated: true)
    }

    override func viewControllers(for pagerViewController: SegmentedPagerViewController) -> [PageContentViewController] {
        return [
            MyTableViewController(style: .plain),
            MyTableViewController(style: .plain),
            MyTableViewController(style: .plain),
            MyTableViewController(style: .plain)
        ]
    }
    
    override func segmentedPager(didShow childController: PageContentViewController, at index: Int) {
        let segmentedControl = self.segmentedControl as! UISegmentedControl
        segmentedControl.selectedSegmentIndex = index
    }
}
