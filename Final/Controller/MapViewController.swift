//
//  MapViewController.swift
//  Final
//
//  Created by evyhsiao on 2021/12/28.
//

import UIKit
import MapKit
import AVFoundation
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var targetPlacemark: CLPlacemark!
    
//    let locationManager = CLLocationManager()
    
    var scene: Scene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure map view
        mapView.delegate = self
        // 允許縮放地圖
        mapView.isZoomEnabled = true
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(scene.address, completionHandler: { placemarks, error in
            if let error = error {
                print("first error", error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                self.targetPlacemark = placemark
                
                // Create annotation object
                let annotation = MKPointAnnotation()
                annotation.title = self.scene.name
                // annotation.subtitle = self.scene.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation view
                    self.mapView.showAnnotations([annotation], animated: true)
                    //select the annotation marker to turn it into the selected state
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
    }
   
    @IBAction func openMap(_ sender: Any) {
        // 顯示自身定位位置
        mapView.showsUserLocation = true
        // enable the voice speaking
        let voiceText = AVSpeechUtterance(string: "Start navigation")
         voiceText.voice = AVSpeechSynthesisVoice(language: "en-US")
         let syn = AVSpeechSynthesizer()
         syn.speak(voiceText)
         
         // open the apple maps and show the route
         let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: targetPlacemark.location!.coordinate, addressDictionary: nil))
         
         mapItem.name = "Destination"
         mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
     }
    
}

// Provide customized annotations

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.centerCoordinate = userLocation.location!.coordinate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {  //unchanged to the marker of the current location
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        annotationView?.glyphImage = UIImage(systemName: "heart")
        annotationView?.markerTintColor = UIColor.orange
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(data: scene.image1)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        return annotationView
    }
}
