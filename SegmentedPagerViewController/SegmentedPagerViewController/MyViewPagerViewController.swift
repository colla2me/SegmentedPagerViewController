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

        // Do any additional setup after loading the view.
    }
    

    override func viewControllers(for pagerViewController: SegmentedPagerViewController) -> [PageContentViewController] {
        return [
            MyTableViewController(style: .plain),
            MyTableViewController(style: .plain),
            MyTableViewController(style: .plain)
        ]
    }
}
