//
//  ViewController.swift
//  CustomSearchBar
//
//  Created by chenchangqing on 12/23/2015.
//  Copyright (c) 2015 chenchangqing. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var tblSearchResults: UITableView!
    
    var dataArray = [String]()
    
    var filteredArray = [String]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        loadListOfCountries()
        
        configureSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Delegate and Datasource functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return dataArray.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath)
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    
    // MARK: - Custom functions
    
    func loadListOfCountries() {
        // Specify the path to the countries list file.
        let pathToFile = NSBundle.mainBundle().pathForResource("countries", ofType: "txt")
        
        if let path = pathToFile {
            // Load the file contents as a string.
            let countriesString = try! String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            
            // Append the countries from the string to the dataArray array by breaking them using the line change character.
            dataArray = countriesString.componentsSeparatedByString("\n")
            
            // Reload the tableview.
            tblSearchResults.reloadData()
        }
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Place the search bar view to the tableview headerview.
//        tblSearchResults.tableHeaderView = searchController.searchBar
        self.navigationItem.titleView = searchController.searchBar
    }
    
    
    // MARK: - UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearchResults.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK: - UISearchResultsUpdating delegate function
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (country) -> Bool in
            let countryText:NSString = country
            
            return (countryText.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblSearchResults.reloadData()
    }

}

