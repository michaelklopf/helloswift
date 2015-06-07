//
//  DetailsViewController.swift
//  HelloWorld2
//
//  Created by Michael on 05.06.15.
//  Copyright (c) 2015 Michael Klopf. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailsViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    lazy var api: APIController = APIController(delegate: self)
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    
    var album: Album?
    var lastSongIndex: Int?
    var lastCell: TrackCell?
    var tracks = [Track]()
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
        let track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶️"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.album != nil {
            api.lookupAlbum(self.album!.collectionId)
        }
        lastSongIndex = -1
        lastCell = nil
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var currentCell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell
        
        if currentCell != lastCell {
            lastCell?.playIcon.text = "▶️"
            lastCell = currentCell
            lastSongIndex = indexPath.row
            var track = tracks[indexPath.row]
            mediaPlayer.stop()
            mediaPlayer.contentURL = NSURL(string: track.previewUrl)
            mediaPlayer.play()
            currentCell!.playIcon.text = "◾️"
        } else {
            mediaPlayer.stop()
            currentCell!.playIcon.text = "▶️"
        }
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.tracksWithJSON(results)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}