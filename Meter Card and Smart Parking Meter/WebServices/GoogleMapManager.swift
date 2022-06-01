//
//  GoogleMapManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 15/03/2022.
//

import Foundation
import GoogleMaps
import CoreLocation

class GoogleMapManager: NSObject {

    static var shared = GoogleMapManager()
    static let API_KEY = "AIzaSyDHfiMj-qKhR14M5zTnqjt3wUeMMTlmwjc"
    let locationManager = CLLocationManager()
    var parkings: [ParkingModel] = []

    private var mapView: GMSMapView?
    private var location_icon: UIImage?
    private var lastLocation: CLLocation?
    private var isSetCurrentLocation = false
    private var isNotDetermined = false

    private override init() {
        super.init()
        self.locationManager.delegate = self
    }

    func initCurrentLocationsAndParkings(mapView: GMSMapView, filter: FilterModel?) {
        self.mapView = mapView
        guard self.hasLocationPermission() else { return }
        self.currentLocation(mapView: mapView, icon: ic_currentMarker._toImage)

        ParkingManager.shared.getParkings(filter: filter) { parkings, errorMessage in
            if let _errorMessage = errorMessage, _errorMessage._isValidValue {
                if let vc = AppDelegate.shared?._topVC {
                    vc._showErrorAlert(message: _errorMessage)
                }
                return
            }
            self.parkings = parkings

            self.parkings.forEach { parking in
                self.setParkingLoction(mapView: mapView, parking: parking)
            }
        }
    }

    func currentLocation(mapView: GMSMapView, icon: UIImage? = nil) {
        location_icon = icon
        self.mapView = mapView
        self.mapView?.clear()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.isSetCurrentLocation = true
    }

    private func setCurrentLocation(coordinate: CLLocationCoordinate2D?) {
        setMarker(name: "current Location", coordinate: coordinate, icon: location_icon)
        moveCamera(coordinate: coordinate)
    }

    func setParkingLoction(mapView: GMSMapView, parking: ParkingModel?, isMoveCamera: Bool = false) {
        guard let parking = parking else { return }

        self.mapView = mapView
        let coordinate = CLLocationCoordinate2D.init(latitude: parking.latitude ?? 0, longitude: parking.longitude ?? 0)
        setMarker(name: parking.name, coordinate: coordinate, icon: ic_parkingMarker._toImage)
        if isMoveCamera {
            moveCamera(coordinate: coordinate)
        }
    }

    private func moveCamera(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }

        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 14)
        self.mapView?.camera = camera
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
        debugPrint("sdds \(self.lastLocation)")
        if let _fromLocation = self.lastLocation {
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

extension GoogleMapManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastLocation = locations.last
        debugPrint("update Location \(self.lastLocation)")
        if isSetCurrentLocation {
            setCurrentLocation(coordinate: self.lastLocation?.coordinate)
            self.isSetCurrentLocation = false
        }
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("err \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.isNotDetermined = true
            manager.requestWhenInUseAuthorization()
            debugPrint("status notDetermined")
            break
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            if let mapView = self.mapView, isNotDetermined {
                initCurrentLocationsAndParkings(mapView: mapView, filter: nil)
                self.isNotDetermined = false
            }
            debugPrint("status authorizedWhenInUse")
            break
        case .restricted, .denied:
            debugPrint("status restricted or denied")
            self.showAlertIfDeniedOrRestricted()
            break
        @unknown default:
            break
        }
    }

    func hasLocationPermission() -> Bool {
        switch self.locationManager.authorizationStatus {
        case .notDetermined:
            return false
        case .restricted, .denied:
            self.showAlertIfDeniedOrRestricted()
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        @unknown default:
            return false
        }
    }
    
    private func showAlertIfDeniedOrRestricted() {
        let vc = AppDelegate.shared?._topVC
        vc?._showAlert(title: "You must allow an app to determine your location", message: "Go to Settings > Privacy > Location Services.", buttonAction1: {
            guard let urlGeneral = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(urlGeneral)
        })
    }

}
