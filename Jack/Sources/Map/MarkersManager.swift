//
//  MarkersManager.swift
//  Jack
//
//  Created by Arthur Ngo Van on 07/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import GoogleMaps
import JackModel
import ArtUtilities

class MarkersManager {
    
    var mapView: GMSMapView

    var markers: [UInt: JKMarker] = [:]
    var currentMarkers: [UInt: JKMarker] = [:]
    
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
            JKMediator.fetchBusiness(boundaries: boundaries, success: { businesses in
                self.addMarkers(businesses)
            }, failure: {})
//            let locations = DataGenerator.shared.locationsInBoundaries(lat1: boundaries.nearLeft.latitude, lng1: boundaries.nearLeft.longitude, lat2: boundaries.farRight.latitude, lng2: boundaries.farRight.longitude)
//            addLocations(locations)
        }
    }
    
    func addMarkers(_ businesses: Array<JKBusiness>) {
        for business in businesses {
            addMarker(business)
            JKBusinessCache.shared.addObject(id: UInt(business.id), object: business)
        }
    }
    
    func addMarker(_ business: JKBusiness) {
        if let marker = markers[business.id] {
            currentMarkers[business.id] = marker
            marker.map = mapView
            return
        }
    
        let marker = JKMarker.init(business)
        
        marker.map = mapView
        
        markers[business.id] = marker
        currentMarkers[business.id] = marker
    }
}

class JKMarker: GMSMarker {
    
    var location: JKLocation
    
    var id: UInt {
        return location.id
    }
    var view: JKMarkerView? {
        return self.iconView as? JKMarkerView
    }
    
    var keep: Bool = false
    
    var displayed: Bool {
        return self.map != nil
    }
    
    init(_ business: JKBusiness) {
        self.location = business.location
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

class GPSPosMarker: GMSMarker {
    
    var location: CLLocation
    
    var view: AUView? {
        return self.iconView as? AUView
    }
    
    var displayed: Bool {
        return self.map != nil
    }
    
    var width: CGFloat = 15
    
    init(_ location: CLLocation) {
        self.location = location
        super.init()
        self.position = location.coordinate
        
        self.iconView = AUView.init(frame: CGRect.init(x: -width / 2, y: -width / 2, width: width, height: width))
        self.tracksViewChanges = true
        
        self.view?.cornerRadiusRatio = 0.5
        self.view?.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        self.view?.borderWidth = 2
        self.view?.borderColor = UIColor.blue
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
