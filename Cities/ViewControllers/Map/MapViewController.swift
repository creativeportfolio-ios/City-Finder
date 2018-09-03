//
//  MapViewController.swift
//  Cities
//
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var city : City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let city = self.city{
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lng)
            annotation.title = city.name
            map.addAnnotation(annotation)
            map.showAnnotations([annotation], animated: true)
        }
    }
}
