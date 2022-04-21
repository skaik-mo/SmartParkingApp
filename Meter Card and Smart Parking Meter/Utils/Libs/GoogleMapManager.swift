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

    static var parkingLocations: [ParkingModel] = []

    static func initLoctionManager(locationManager: CLLocationManager?, mapView: GMSMapView) {
        guard let _locationManager = locationManager else { return }
        _locationManager.requestWhenInUseAuthorization()
        
        mapView.clear()
        
        self.parkingLocations = [
            ParkingModel.init(name: "Prospect Garden", imageURL: "demo", rating: 0, price: "11", latitude: 51.5125, longitude: -0.1395),
            ParkingModel.init(name: "City Square Gardens", imageURL: "ic_image", rating: 1.1, price: "22.2", latitude: 51.5127, longitude: -0.135),
            ParkingModel.init(name: "Peace Gardens", imageURL: "ic_image", rating: 2.2, price: "33.33", latitude: 51.5084, longitude: -0.136),
            ParkingModel.init(name: "Sea Breeze Meadows", imageURL: "ic_image", rating: 3.3, price: "44", latitude: 51.5068, longitude: -0.1288),
            ParkingModel.init(name: "Red Tail Park", imageURL: "ic_image", rating: 4.4, price: "55.555", latitude: 51.5163, longitude: -0.1391),
            ParkingModel.init(name: "My Parking", imageURL: "demo", rating: 4.5, price: "90", latitude: 51.5068, longitude: -0.1338)
        ]

//        mapView.isMyLocationEnabled = true

        self.parkingLocations.forEach { location in
            setMarker(mapView: mapView, parkingLocation: location, icon: "ic_parking"._toImage)
        }

//        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
        currentLocation(mapView: mapView, coordinate: locationManager?.location?.coordinate)
//        }
    }

    static func initParkingLoction(parkingLocation: ParkingModel?, mapView: GMSMapView) {
        setMarker(mapView: mapView, parkingLocation: parkingLocation, icon: "ic_parking"._toImage)
        moveCamera(mapView: mapView, parkingLocation: parkingLocation, zoom: 16)
    }

    static func currentLocation(mapView: GMSMapView, coordinate: CLLocationCoordinate2D?, icon: UIImage? = "ic_currentMarker"._toImage) {
        guard let _coordinate = coordinate else { return }
        
        let currentLocation = ParkingModel.init(name: "Current Location", latitude: _coordinate.latitude, longitude: _coordinate.longitude)

        setMarker(mapView: mapView, parkingLocation: currentLocation, icon: icon)
        moveCamera(mapView: mapView, parkingLocation: currentLocation)
    }

    static func moveCamera(mapView: GMSMapView, parkingLocation: ParkingModel?, zoom: Float = 14) {
        guard let _parkingLocation = parkingLocation, let _latitude = _parkingLocation.latitude, let _longitude = _parkingLocation.longitude else { return }

        let camera = GMSCameraPosition.camera(withLatitude: _latitude, longitude: _longitude, zoom: zoom)
        mapView.camera = camera
    }

    static func setMarker(mapView: GMSMapView, parkingLocation: ParkingModel?, icon: UIImage? = nil) {
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
        let vc: HomeUserViewController = HomeUserViewController._instantiateVC(storyboard: HomeUserViewController()._userStoryboard)
        let fromLocation = vc.locationManager.location
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
