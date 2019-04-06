//
//  MyTableViewController.swift
//  Example-Swift
//
//  Created by samuel on 2019/4/6.
//  Copyright © 2019 samuel. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController, PageContentViewController {
    
    var scrollView: UIScrollView {
        return self.tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 64.0
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "mycell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel?.text = "cell at row \(indexPath.row)"
        return cell
    }

}
