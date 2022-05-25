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

    static var parkings: [ParkingModel] = []

    static func initCurrentLocationsAndParkings(mapView: GMSMapView, filter: FilterModel?) {

        ParkingManager.shared.getParkings(filter: filter) { parkings, message in
            if let _message = message, _message._isValidValue {
                if let vc = AppDelegate.shared?._topVC {
                    vc._showErrorAlert(message: _message)
                }
                return
            }
            self.parkings = parkings
            self.setCurrentLocationsAndParkings(mapView: mapView)
        }

//        self.parkings = [
//            ParkingModel.init(uid: nil, name: "Prospect Garden", parkingImageURL: "demo", rating: 0, price: "11", latitude: 51.5125, longitude: -0.1395),
//            ParkingModel.init(uid: nil, name: "City Square Gardens", parkingImageURL: "ic_image", rating: 1.1, price: "22.2", latitude: 51.5127, longitude: -0.135),
//            ParkingModel.init(uid: nil, name: "Peace Gardens", parkingImageURL: "ic_image", rating: 2.2, price: "33.33", latitude: 51.5084, longitude: -0.136),
//            ParkingModel.init(uid: nil, name: "Sea Breeze Meadows", parkingImageURL: "ic_image", rating: 3.3, price: "44", latitude: 51.5068, longitude: -0.1288),
//            ParkingModel.init(uid: nil, name: "Red Tail Park", parkingImageURL: "ic_image", rating: 4.4, price: "55.555", latitude: 51.5163, longitude: -0.1391),
//            ParkingModel.init(uid: nil, name: "My Parking", parkingImageURL: "demo", rating: 4.5, price: "90", latitude: 51.5068, longitude: -0.1338)
//        ]

    }

    static func setCurrentLocationsAndParkings(mapView: GMSMapView) {
        locationManager.requestWhenInUseAuthorization()

        mapView.clear()

        self.parkings.forEach { parking in
            setMarker(mapView: mapView, name: parking.name, latitude: parking.latitude, longitude: parking.longitude, icon: "ic_parking"._toImage)
        }

        currentLocation(mapView: mapView, name: "current Location", icon: "ic_currentMarker"._toImage)
    }

    static func initParkingLoction(parking: ParkingModel?, mapView: GMSMapView) {
        setMarker(mapView: mapView, name: parking?.name, latitude: parking?.latitude, longitude: parking?.longitude, icon: "ic_parking"._toImage)
        moveCamera(mapView: mapView, latitude: parking?.latitude, longitude: parking?.longitude, zoom: 16)
    }

    static func currentLocation(mapView: GMSMapView, coordinate: CLLocationCoordinate2D? = nil, name: String? = nil, icon: UIImage? = nil, isMoveCamera: Bool? = true) {
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        var _coordinate = locationManager.location?.coordinate
        if let coordinate = coordinate {
            _coordinate = coordinate
        }
        setMarker(mapView: mapView, name: name, latitude: _coordinate?.latitude, longitude: _coordinate?.longitude, icon: icon)
        if isMoveCamera ?? false {
            moveCamera(mapView: mapView, latitude: _coordinate?.latitude, longitude: _coordinate?.longitude)
        }
    }

    private static func moveCamera(mapView: GMSMapView, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?, zoom: Float = 14) {
        guard let _latitude = latitude, let _longitude = longitude else { return }

        let camera = GMSCameraPosition.camera(withLatitude: _latitude, longitude: _longitude, zoom: zoom)
        mapView.camera = camera
    }

    private static func setMarker(mapView: GMSMapView, name: String? = nil, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?, icon: UIImage? = nil) {
        guard let _latitude = latitude, let _longitude = longitude else { return }

        let marker = GMSMarker()
        marker.icon = icon
        marker.position = CLLocationCoordinate2D(latitude: _latitude, longitude: _longitude)
        marker.title = name

        marker.isFlat = true
        marker.tracksInfoWindowChanges = true

        marker.map = mapView

    }

    static func getDistance(toLocation: CLLocation) -> Double {
        let fromLocation = locationManager.location
        if let _fromLocation = fromLocation {
            let distance = _fromLocation.distance(from: toLocation) / 1000
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
