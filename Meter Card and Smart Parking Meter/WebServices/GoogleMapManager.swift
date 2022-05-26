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
    var parkings: [ParkingModel] = []

    private var location_icon: UIImage?
    private var mapView: GMSMapView!

    //        self.parkings = [
    //            ParkingModel.init(uid: nil, name: "Prospect Garden", parkingImageURL: "demo", rating: 0, price: "11", latitude: 51.5125, longitude: -0.1395),
    //            ParkingModel.init(uid: nil, name: "City Square Gardens", parkingImageURL: "ic_image", rating: 1.1, price: "22.2", latitude: 51.5127, longitude: -0.135),
    //            ParkingModel.init(uid: nil, name: "Peace Gardens", parkingImageURL: "ic_image", rating: 2.2, price: "33.33", latitude: 51.5084, longitude: -0.136),
    //            ParkingModel.init(uid: nil, name: "Sea Breeze Meadows", parkingImageURL: "ic_image", rating: 3.3, price: "44", latitude: 51.5068, longitude: -0.1288),
    //            ParkingModel.init(uid: nil, name: "Red Tail Park", parkingImageURL: "ic_image", rating: 4.4, price: "55.555", latitude: 51.5163, longitude: -0.1391),
    //            ParkingModel.init(uid: nil, name: "My Parking", parkingImageURL: "demo", rating: 4.5, price: "90", latitude: 51.5068, longitude: -0.1338)
    //        ]

    func initCurrentLocationsAndParkings(mapView: GMSMapView, filter: FilterModel?) {

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
    }

    func setCurrentLocationsAndParkings(mapView: GMSMapView) {
        self.mapView = mapView

        currentLocation(mapView: mapView, icon: "ic_currentMarker"._toImage)

        self.parkings.forEach { parking in
            setParkingLoction(mapView: mapView, parking: parking)
        }
    }

    func currentLocation(mapView: GMSMapView, coordinate: CLLocationCoordinate2D? = nil, icon: UIImage? = nil) {
        location_icon = icon
        mapView.clear()
        self.mapView = mapView
        var coord = coordinate
        if coordinate == nil {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
            coord = self.locationManager.location?.coordinate
        }
        setCurrentLocation(cordinate: coord)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            setCurrentLocation(cordinate: location.coordinate)
        }
        manager.stopUpdatingLocation()
    }

    private func setCurrentLocation(cordinate: CLLocationCoordinate2D?) {
        setMarker(name: "current Location", cordinate: cordinate, icon: location_icon)
        moveCamera(cordinate: cordinate)
    }

    func setParkingLoction(mapView: GMSMapView, parking: ParkingModel?) {
        guard let parking = parking else { return }

        self.mapView = mapView
        let cord = CLLocationCoordinate2D.init(latitude: parking.latitude ?? 0, longitude: parking.longitude ?? 0)
        setMarker(name: parking.name, cordinate: cord, icon: "ic_parking"._toImage)
        moveCamera(cordinate: cord)
    }

    private func moveCamera(cordinate: CLLocationCoordinate2D?) {
        guard let cord = cordinate else { return }

        let camera = GMSCameraPosition.camera(withLatitude: cord.latitude, longitude: cord.longitude, zoom: 14)
        self.mapView.camera = camera
    }

    private func setMarker(name: String? = nil, cordinate: CLLocationCoordinate2D?, icon: UIImage? = nil) {
        guard let cord = cordinate else { return }

        let marker = GMSMarker()
        marker.icon = icon
        marker.position = CLLocationCoordinate2D(latitude: cord.latitude, longitude: cord.longitude)
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


    func getPlaceAddressFrom(location: CLLocationCoordinate2D?, completion: @escaping (_ address: String) -> Void) {
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
