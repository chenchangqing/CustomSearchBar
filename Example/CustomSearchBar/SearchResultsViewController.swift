//
//  SearchResultsViewController.swift
//  CustomSearchBar
//
//  Created by green on 15/12/24.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController {
    
    var filteredArray = [String]()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = filteredArray[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60.0
    }

}
