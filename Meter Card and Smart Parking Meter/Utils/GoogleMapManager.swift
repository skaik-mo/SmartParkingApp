//
//  GoogleMapManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import Foundation
import GoogleMaps

class GoogleMapManager {

    static let API_KEY = "AIzaSyDHfiMj-qKhR14M5zTnqjt3wUeMMTlmwjc"

    static var parkingLocations: [Parking] = []

    static func initLoctionManager(locationManager: CLLocationManager?, mapView: GMSMapView) {
        guard let _locationManager = locationManager else { return }
        _locationManager.requestWhenInUseAuthorization()

        self.parkingLocations = [
            Parking.init(title: "Prospect Garden", image: "demo"._toImage, rating: 0, pricePerHour: 11, latitude: 51.5125, longitude: -0.1395),
            Parking.init(title: "City Square Gardens", image: "ic_image"._toImage, rating: 1.1, pricePerHour: 22.2, latitude: 51.5127, longitude: -0.135),
            Parking.init(title: "Peace Gardens", image: "ic_image"._toImage, rating: 2.2, pricePerHour: 33.33, latitude: 51.5084, longitude: -0.136),
            Parking.init(title: "Sea Breeze Meadows", image: "ic_image"._toImage, rating: 3.3, pricePerHour: 44, latitude: 51.5068, longitude: -0.1288),
            Parking.init(title: "Red Tail Park", image: "ic_image"._toImage, rating: 4.4, pricePerHour: 55.555, latitude: 51.5163, longitude: -0.1391),
            Parking.init(title: "My Parking", image: "demo"._toImage, rating: 4.5, pricePerHour: 90, latitude: 51.5068, longitude: -0.1338)
        ]

        mapView.isMyLocationEnabled = true

        self.parkingLocations.forEach { location in
            setMarker(mapView: mapView, parkingLocation: location, icon: "ic_parking"._toImage)
        }

//        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
        currentLocation(mapView: mapView, locationManager: locationManager)
//        }
//        moveCamera(mapView: mapView, parkingLocation: parkingLocations.first)
    }

    static func initLoction(parkingLocation: Parking?, mapView: GMSMapView) {
        setMarker(mapView: mapView, parkingLocation: parkingLocation, icon: "ic_parking"._toImage)
        moveCamera(mapView: mapView, parkingLocation: parkingLocation)
    }

    static func currentLocation(mapView: GMSMapView, locationManager: CLLocationManager?) {

        guard let _locationManager = locationManager else { return }

        let currentLocation = Parking.init(title: "Current Location", latitude: _locationManager.location?.coordinate.latitude, longitude: _locationManager.location?.coordinate.longitude)

        setMarker(mapView: mapView, parkingLocation: currentLocation)
        moveCamera(mapView: mapView, parkingLocation: currentLocation)
    }

    static func moveCamera(mapView: GMSMapView, parkingLocation: Parking?) {
        guard let _parkingLocation = parkingLocation, let _latitude = _parkingLocation.latitude, let _longitude = _parkingLocation.longitude else { return }

        let camera = GMSCameraPosition.camera(withLatitude: _latitude, longitude: _longitude, zoom: 17.0)
        mapView.camera = camera
    }

    static func setMarker(mapView: GMSMapView, parkingLocation: Parking?, icon: UIImage? = nil) {
        guard let _parkingLocation = parkingLocation, let _latitude = _parkingLocation.latitude, let _longitude = _parkingLocation.longitude else { return }

        let marker = GMSMarker()
        marker.icon = icon
        marker.position = CLLocationCoordinate2D(latitude: _latitude, longitude: _longitude)
        marker.title = _parkingLocation.name

        marker.isFlat = true
        marker.tracksInfoWindowChanges = true

        marker.map = mapView

    }

    static func getDistance(toLocation: CLLocation) -> Double {
        let vc = HomeViewController._storyborad as? HomeViewController
        let fromLocation = vc?.locationManager.location
        if let _fromLocation = fromLocation {
            let distance = _fromLocation.distance(from: toLocation) / 1000
//            print(String(format: "The distance to my buddy is %.01fkm", distance))
            return distance
        }
        return 0
    }


    static func getPlaceAddressFrom(location: CLLocationCoordinate2D?, completion: @escaping (_ address: String) -> Void) {
        guard let _location = location else { return }
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(_location) { response, error in

            if error != nil {
                debugPrint("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                guard let places = response?.firstResult(), let place = places.lines else {
                    completion("")
                    return
                }
                completion(place.joined(separator: ","))
            }
        }
    }




}
