//
//  Track.swift
//  HelloWorld2
//
//  Created by Michael on 06.06.15.
//  Copyright (c) 2015 Michael Klopf. All rights reserved.
//

import Foundation

struct Track {
    let title: String
    let price: Float
    let previewUrl: String
    
    init(title: String, price: Float, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    static func tracksWithJSON(results: NSArray) -> [Track] {
        var tracks = [Track]()
        for trackInfo in results {
            // Create the track
            if let kind = trackInfo["kind"] as? String {
                if kind == "song" {
                    var trackPrice = trackInfo["trackPrice"] as? Float
                    var trackTitle = trackInfo["trackName"] as? String
                    var trackPreviewUrl = trackInfo["previewUrl"] as? String
                    
                    // println("Values \(trackPrice)  \(trackTitle)  \(trackPreviewUrl)")
                    
                    if(trackTitle == nil) {
                        trackTitle = "Unknown"
                    }
                    else if(trackPrice == nil) {
                        println("No trackPrice in \(trackInfo)")
                        trackPrice = 0.00
                    }
                    else if(trackPreviewUrl == nil) {
                        trackPreviewUrl = ""
                    }
                    var track = Track(title: trackTitle!, price: trackPrice!, previewUrl: trackPreviewUrl!)
                    tracks.append(track)
                }
            }
        }
        return tracks
    }
}