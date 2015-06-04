//
//  SearchResultsViewController.swift
//  HelloWorld2
//
//  Created by Michael on 02.06.15.
//  Copyright (c) 2015 Michael Klopf. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    let kCellIdentifier: String = "SearchResultCell"
    
    var tableData = []
    
    var imageCache = [String:UIImage]()
    
    let api = APIController()
    
    @IBOutlet var appsTableView : UITableView!

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        if let rowData = self.tableData[indexPath.row] as? NSDictionary,
            // Get the name of the track for this row
            name = rowData["trackName"] as? String,
            // Get the price of the track on this row
            formattedPrice = rowData["formattedPrice"] as? String {
                let alert = UIAlertController(title: name, message: formattedPrice, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            urlString = rowData["artworkUrl60"] as? String,
            // Create an NSURL instance from the String URL we get from the API
            imgURL = NSURL(string: urlString),
            // Get the formatted price string for display in the subtitle
            formattedPrice = rowData["formattedPrice"] as? String,
            // Download an NSData representation of the image at the URL
            //imgData = NSData(contentsOfURL: imgURL),
            // Get the track name
            trackName = rowData["trackName"] as? String {
                // Get the formatted price string for display in the subtitle
                cell.detailTextLabel?.text = formattedPrice
                // Update the textLabel text to use the trackName from the API
                cell.textLabel?.text = trackName
                // Update the imageView cell to use the downloaded image data
                cell.imageView?.image = UIImage(named: "Blank52")
                // If this image is already cached, don't re-download
                if let img = imageCache[urlString] {
                    cell.imageView?.image = img
                }
                else {
                    // The image isn't cached, download the img data
                    // We should perform this in a background thread
                    let request: NSURLRequest = NSURLRequest(URL: imgURL)
                    let mainQueue = NSOperationQueue.mainQueue()
                    NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                        if error == nil {
                            // Convert the downloaded data in to a UIImage object
                            let image = UIImage(data: data)
                            // Store the image in to our cache
                            self.imageCache[urlString] = image
                            // Update the cell
                            dispatch_async(dispatch_get_main_queue(), {
                                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                                    cellToUpdate.imageView?.image = image
                                }
                            })
                        }
                        else {
                            println("Error: \(error.localizedDescription)")
                        }
                    })
                }
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

