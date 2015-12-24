//
//  ViewController.swift
//  CustomSearchBar
//
//  Created by chenchangqing on 12/23/2015.
//  Copyright (c) 2015 chenchangqing. All rights reserved.
//

import UIKit

let NAVIGATION_BORDER_COLOR:UIColor = UIColor(red: 236.0/255.0, green: 0.0/255.0, blue: 39.0/255.0, alpha: 1.0)
let NAVIGATION_BORDER_WIDTH:CGFloat = 2.0
let NAVIGATION_BORDER_TAG:Int = 100

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var tblSearchResults: UITableView!
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    
    var dataArray = [String]()
    
    var filteredArray = [String]()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    var uiSearchBarView: UIView!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        loadListOfCountries()
        
        configureSearchBarButtonItem()
        configureNavigationBar()
        configureSearchController()
        configureSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func configureSearchBarButtonItem() {
        
        searchBarButtonItem.tintColor = NAVIGATION_BORDER_COLOR
    }
    
    func configureNavigationBar() {
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.viewWithTag(NAVIGATION_BORDER_TAG)?.removeFromSuperview()
        
        let navigationBarBorderOrigin   = CGPoint(x: 0, y: self.navigationController!.navigationBar.frame.height)
        let navigationBarBorderSize     = CGSize(width: self.navigationController!.navigationBar.frame.width, height: NAVIGATION_BORDER_WIDTH)
        let navigationbarBorderRect     = CGRect(origin: navigationBarBorderOrigin, size: navigationBarBorderSize)
        let navigationBarBorder         = UIView(frame: navigationbarBorderRect)
        
        navigationBarBorder.backgroundColor = NAVIGATION_BORDER_COLOR
        navigationBarBorder.opaque          = true
        navigationBarBorder.tag             = NAVIGATION_BORDER_TAG
        
        self.navigationController!.navigationBar.addSubview(navigationBarBorder)
    }
    
    func configureSearchController() {

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
    
    }
    
    func configureSearchBar() {
        
        let uiSearchBarViewRect = CGRect(origin: CGPoint(x: 0, y: -64), size: CGSize(width: self.view.frame.width, height: 64))
        uiSearchBarView = UIView(frame: uiSearchBarViewRect)
        uiSearchBarView.backgroundColor = UIColor.whiteColor()
        
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = UIColor.whiteColor()
        searchController.searchBar.tintColor = NAVIGATION_BORDER_COLOR
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.sizeToFit()
        
        let contanier = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 20), size: CGSize(width: self.view.frame.width, height: 44)))
        contanier.addSubview(searchController.searchBar)
        uiSearchBarView.addSubview(contanier)
        
        self.navigationController!.view.addSubview(uiSearchBarView)
        
    }
    
    @IBAction func startSearch(sender: UIBarButtonItem) {
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.uiSearchBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
            self.searchController.searchBar.becomeFirstResponder()
        }
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
    
    
    // MARK: - UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.searchController.searchBar.text = ""
            self.searchController.searchBar.resignFirstResponder()
            self.uiSearchBarView.frame = CGRectMake(0, -64, self.view.frame.width, 64)
        }
        
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

