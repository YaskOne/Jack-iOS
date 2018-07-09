//
//  MapViewController.swift
//  Jack
//
//  Created by Arthur Ngo Van on 06/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var mapView: GMSMapView?
    
    let geocoder = GMSGeocoder()
    
    var markersManager: MarkersManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(
            withLatitude: JKSession.shared.lastPos?.coordinate.latitude ?? 51.5,
            longitude: JKSession.shared.lastPos?.coordinate.longitude ?? -0.127,
                                              zoom: 14)
        mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        view = mapView
        mapView?.delegate = self
        
        markersManager = MarkersManager.init(mapView: mapView!)
    }
    
    func flyToLocation(lat: Double, lng: Double, zoom: Float = 14) {
        mapView?.animate(to: GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: zoom, bearing: 0, viewingAngle: 0))
    }
    
    func normalizeDirection() {
        mapView?.animate(toBearing: 0)
    }
}

extension MapViewController: GMSMapViewDelegate {
    
//    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
//        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
//            guard error == nil else {
//                return
//            }
//
//            if let result = response?.firstResult() {
//                let marker = GMSMarker()
//                marker.position = cameraPosition.target
//                marker.title = result.lines?[0]
//                marker.snippet = result.lines?[1]
//                marker.map = mapView
//            }
//        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        markersManager?.fetchMarkers(JKBoundaries( mapView.projection.visibleRegion()))
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let marker = marker as? JKMarker {
            NotificationCenter.default.post(name: openLocationOverviewNotification, object: nil, userInfo: ["id": marker.id])
        }
//        // remove color from currently selected marker
//        if let selectedMarker = self.mapView?.selectedMarker {
//            (selectedMarker.iconView as? JKMarkerView)?.selected = false
//        }
//
//        // select new marker and make green
//        self.mapView?.selectedMarker = marker
//        (marker.iconView as? JKMarkerView)?.selected = true
//
//        // tap event handled by delegate
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        (marker.iconView as? JKMarkerView)?.selected = false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let marker = marker as? JKMarker {
            NotificationCenter.default.post(name: openLocationNotification, object: nil, userInfo: ["id": marker.id])
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
    }
    
//    func mapView(_ mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
//        let customInfoWindow = JKMarkerInfoView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 80))
//        if let marker = marker as? JKMarker {
//            customInfoWindow.nameLabel.text = marker.location.name
//            customInfoWindow.descriptionLabel.text = marker.location.type
//        }
//        return customInfoWindow
//    }
}
