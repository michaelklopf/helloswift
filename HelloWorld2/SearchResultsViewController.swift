//
//  SearchResultsViewController.swift
//  HelloWorld2
//
//  Created by Michael on 02.06.15.
//  Copyright (c) 2015 Michael Klopf. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var tableData = []
    
    let api = APIController()
    
    @IBOutlet var appsTableView : UITableView!

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            urlString = rowData["artworkUrl60"] as? String,
            // Create an NSURL instance from the String URL we get from the API
            imgURL = NSURL(string: urlString),
            // Get the formatted price string for display in the subtitle
            formattedPrice = rowData["formattedPrice"] as? String,
            // Download an NSData representation of the image at the URL
            imgData = NSData(contentsOfURL: imgURL),
            // Get the track name
            trackName = rowData["trackName"] as? String {
                // Get the formatted price string for display in the subtitle
                cell.detailTextLabel?.text = formattedPrice
                // Update the imageView cell to use the downloaded image data
                cell.imageView?.image = UIImage(data: imgData)
                // Update the textLabel text to use the trackName from the API
                cell.textLabel?.text = trackName
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api.searchItunesFor("Angry Birds")
        api.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.appsTableView!.reloadData()
        })
    }

}

