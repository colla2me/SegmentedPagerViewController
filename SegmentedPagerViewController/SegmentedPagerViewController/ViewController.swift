//
//  ViewController.swift
//  SegmentedPagerViewController
//
//  Created by samuel on 2019/4/6.
//  Copyright © 2019 samuel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onTapButton(_ sender: Any) {
        self.navigationController?.pushViewController(MyViewPagerViewController(), animated: true)
    }
}

