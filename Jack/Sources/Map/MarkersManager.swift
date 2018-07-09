//
//  MarkersManager.swift
//  Jack
//
//  Created by Arthur Ngo Van on 07/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import GoogleMaps

class MarkersManager {
    
    var mapView: GMSMapView

    var markers: [Int: JKMarker] = [:]
    var currentMarkers: [Int: JKMarker] = [:]
    
    var keepOldLocations: Bool = false
    
    var now: DispatchTime {
        return DispatchTime.now()
    }
    var lastFetch: DispatchTime?
    
    init(mapView: GMSMapView) {
        self.mapView = mapView
        lastFetch = now
    }
    
    func fetchMarkers(_ boundaries: JKBoundaries) {
        if let lastFetch = lastFetch, lastFetch.uptimeNanoseconds < now.uptimeNanoseconds - 10000000 {
            self.lastFetch = now
            let locations = DataGenerator.shared.locationsInBoundaries(lat1: boundaries.nearLeft.latitude, lng1: boundaries.nearLeft.longitude, lat2: boundaries.farRight.latitude, lng2: boundaries.farRight.longitude)
            addLocations(locations)
        }
    }
    
    func addLocations(_ locations: Array<JKLocation>) {
        var locations = locations
        for (i,location) in locations.enumerated().reversed() {
            if let marker = currentMarkers[location.id] {
                if marker.displayed {
                    marker.map = mapView
                }
                marker.keep = true
                locations.remove(at: i)
            }
        }
        for marker in currentMarkers.values {
            if !keepOldLocations && !marker.keep {
                marker.map = nil
                currentMarkers.removeValue(forKey: marker.id)
            }
            else {
                marker.keep = false
            }
        }
        for location in locations {
            addMarker(location)
        }
    }
    
    func addMarker(_ location: JKLocation) {
        if let marker = markers[location.id] {
            currentMarkers[location.id] = marker
            marker.map = mapView
            return
        }
    
        let marker = JKMarker.init(location)
        
        marker.map = mapView
        
        markers[location.id] = marker
        currentMarkers[location.id] = marker
    }
}

class JKMarker: GMSMarker {
    
    var location: JKLocation
    
    var id: Int {
        return location.id
    }
    var view: JKMarkerView? {
        return self.iconView as? JKMarkerView
    }
    
    var keep: Bool = false
    
    var displayed: Bool {
        return self.map != nil
    }
    
    init(_ location: JKLocation) {
        self.location = location
        super.init()
        self.position = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
        
        self.iconView = JKMarkerView(frame: CGRect.init(x: 0, y: 0, width: 105 * 0.6, height: 120 * 0.6))
        self.tracksViewChanges = true
        
        if let markerView = self.iconView as? JKMarkerView {
            markerView.imageView.isHidden = true
            JKImageLoader.loadImage(imageView: markerView.imageView, url: location.url) {}
            //            markerView.imageView.imageFromURL(urlString: location.url)
        }
    }
    
}

class JKBoundaries {
    
    var nearLeft: CLLocationCoordinate2D
    var farRight: CLLocationCoordinate2D
    
    init(_ boundaries: GMSVisibleRegion) {
        nearLeft = boundaries.nearLeft
        farRight = boundaries.farRight
    }
    
}
