//
//  GoogleMapManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import Foundation
import GoogleMaps
import CoreLocation

class GoogleMapManager: NSObject, CLLocationManagerDelegate {

    static var shared = GoogleMapManager()
    let API_KEY = "AIzaSyDHfiMj-qKhR14M5zTnqjt3wUeMMTlmwjc"
    let locationManager = CLLocationManager()
    private var mapView: GMSMapView!

    var parkings: [ParkingModel] = []
    private var location_icon: UIImage?

    func initCurrentLocationsAndParkings(mapView: GMSMapView, filter: FilterModel?) {
        ParkingManager.shared.getParkings(filter: filter) { parkings, errorMessage in
            if let _errorMessage = errorMessage, _errorMessage._isValidValue {
                if let vc = AppDelegate.shared?._topVC {
                    vc._showErrorAlert(message: _errorMessage)
                }
                return
            }
            self.parkings = parkings
            self.setCurrentLocationsAndParkings(mapView: mapView)
        }
    }

    func setCurrentLocationsAndParkings(mapView: GMSMapView) {
        self.currentLocation(mapView: mapView, icon: "ic_currentMarker"._toImage)

        self.parkings.forEach { parking in
            setParkingLoction(mapView: mapView, parking: parking)
        }
    }

    func currentLocation(mapView: GMSMapView, icon: UIImage? = nil) {
        location_icon = icon
        self.mapView = mapView
        self.mapView.clear()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            debugPrint("update Location")
            setCurrentLocation(coordinate: location.coordinate)
        }
        manager.stopUpdatingLocation()
    }

    private func setCurrentLocation(coordinate: CLLocationCoordinate2D?) {
        setMarker(name: "current Location", coordinate: coordinate, icon: location_icon)
        moveCamera(coordinate: coordinate)
    }

    func setParkingLoction(mapView: GMSMapView, parking: ParkingModel?, isMoveCamera: Bool = false) {
        guard let parking = parking else { return }

        self.mapView = mapView
        let coordinate = CLLocationCoordinate2D.init(latitude: parking.latitude ?? 0, longitude: parking.longitude ?? 0)
        setMarker(name: parking.name, coordinate: coordinate, icon: "ic_parking"._toImage)
        if isMoveCamera {
            moveCamera(coordinate: coordinate)
        }
    }

    private func moveCamera(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }

        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 14)
        self.mapView.camera = camera
    }

    func setMarker(name: String? = nil, coordinate: CLLocationCoordinate2D?, icon: UIImage? = nil) {
        guard let coordinate = coordinate else { return }

        let marker = GMSMarker()
        marker.icon = icon
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.title = name

        marker.isFlat = true
        marker.tracksInfoWindowChanges = true

        marker.map = self.mapView
    }

    func getDistance(toLocation: CLLocation) -> Double {
        let fromLocation = locationManager.location
        if let _fromLocation = fromLocation {
            let distance = _fromLocation.distance(from: toLocation) / 1000
            return distance
        }
        return 0
    }


    func getPlaceAddressFrom(coordinate: CLLocationCoordinate2D?, completion: @escaping (_ address: String) -> Void) {
        guard let coordinate = coordinate else { return }
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in

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

//        self.parkings = [
//            ParkingModel.init(uid: nil, name: "Prospect Garden", parkingImageURL: "demo", rating: 0, price: "11", latitude: 51.5125, longitude: -0.1395),
//            ParkingModel.init(uid: nil, name: "City Square Gardens", parkingImageURL: "ic_image", rating: 1.1, price: "22.2", latitude: 51.5127, longitude: -0.135),
//            ParkingModel.init(uid: nil, name: "Peace Gardens", parkingImageURL: "ic_image", rating: 2.2, price: "33.33", latitude: 51.5084, longitude: -0.136),
//            ParkingModel.init(uid: nil, name: "Sea Breeze Meadows", parkingImageURL: "ic_image", rating: 3.3, price: "44", latitude: 51.5068, longitude: -0.1288),
//            ParkingModel.init(uid: nil, name: "Red Tail Park", parkingImageURL: "ic_image", rating: 4.4, price: "55.555", latitude: 51.5163, longitude: -0.1391),
//            ParkingModel.init(uid: nil, name: "My Parking", parkingImageURL: "demo", rating: 4.5, price: "90", latitude: 51.5068, longitude: -0.1338)
//        ]
