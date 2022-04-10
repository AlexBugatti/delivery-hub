//
//  MapController.swift
//  delivery-hub
//
//  Created by Александр on 09.04.2022.
//

import UIKit
import MapKit

class MapController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocation?
    var activeOrder: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        mapView.showsUserLocation = true
        mapView.delegate = self
        configureLocationManager()
        checkLocationServices()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkActiveOrders()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    func checkLocationServices() {
          if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
          } else {
            // Show alert letting the user know they have to turn this on.
          }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                break
            case .denied: // Show alert telling users how to turn on permissions
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted: // Show an alert letting them know what’s up
                break
            case .authorizedAlways:
                break
            @unknown default:
                break
        }
    }
    
    func checkActiveOrders() {
        activeOrder = DatabaseService.shared.getOrders().first(where: { $0.state == .active })
        if let activeOrder = activeOrder {
            self.locationManager.startUpdatingLocation()
            let shops = ShopResponse.all()
            if let shop = shops.first(where: { activeOrder.shopId == $0.id }) {
                let position = CLLocationCoordinate2DMake(shop.coordinate.latitude,
                                                          shop.coordinate.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = position
                annotation.title = shop.name
                mapView.addAnnotation(annotation)
            }
        } else {
            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func updateRoute() {
        if let userLocation = userLocation, let order = activeOrder {
            let shops = ShopResponse.all()
            if let shop = shops.first(where: { order.shopId == $0.id }) {
                let position = CLLocationCoordinate2DMake(shop.coordinate.latitude,
                                                          shop.coordinate.longitude)
                self.showRouteOnMap(pickupCoordinate: userLocation.coordinate, destinationCoordinate: position)
            }
        } else {
            if let userLocation = userLocation {
                self.mapView.setCenter(userLocation.coordinate, animated: false)
            }
        }
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

//        let sourceAnnotation = MKPointAnnotation()
//
//        if let location = sourcePlacemark.location {
//            sourceAnnotation.coordinate = location.coordinate
//        }
//
//        let destinationAnnotation = MKPointAnnotation()
//
//        if let location = destinationPlacemark.location {
//            destinationAnnotation.coordinate = location.coordinate
//        }

//        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile

        // Calculate the direction
        let directions = MKDirections(request: directionRequest)

        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }

            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: false)
        }
    }
    
    func getAddress() {
        if let location = locationManager.location {
            APIService().reverseGeocode(coordinate: location.coordinate) { response, errorString in
                print(response)
                if let first = response?.suggestions.first {
                    DispatchQueue.main.async {
                        self.addressLabel.text = first.value
                    }
                }
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations.last
        self.updateRoute()
        self.getAddress()
    }
    
}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
    
}
