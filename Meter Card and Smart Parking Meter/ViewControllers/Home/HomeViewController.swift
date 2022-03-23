//  Skaik_mo
//
//  HomeViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 12/03/2022.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var currentLocationButton: UIButton!
    
    @IBOutlet weak var parkingInfo: ParkingInfo!
    
    var locationManager = CLLocationManager()

    var isShowParkingInfo = false {
        didSet {
            self.switchComponents()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared?.rootNavigationController?.setTransparentNavigation()

    }

    @IBAction func filtersAction(_ sender: Any) {
        FiltersViewController._presentVC()

    }
    @IBAction func currentLocationAction(_ sender: Any) {
        GoogleMapManager.currentLocation(mapView: mapView, locationManager: locationManager)
//        AlertViewController._presentVC()
    }
    
    @IBAction func profileAction(_ sender: Any) {
        ProfileViewController._push()
    }
    

}

extension HomeViewController {

    func setupView() {
        self.title = "Home"
        setUpMap()
        
        switchComponents()
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }
    
    func switchComponents() {
        self.parkingInfo.isHidden = !self.isShowParkingInfo
        self.currentLocationButton.isHidden = self.isShowParkingInfo
    }
    

}

extension HomeViewController: GMSMapViewDelegate {

    func setUpMap() {
        mapView.delegate = self
        GoogleMapManager.initLoctionManager(locationManager: locationManager, mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        GoogleMapManager.parkingLocations.forEach { parking in
            if marker.position.latitude == parking.latitude, marker.position.longitude == parking.longitude, marker.title == parking.name {
                self.parkingInfo.parking = parking
                self.parkingInfo.setUpView()
                return
            }
        }
        self.isShowParkingInfo = true
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.isShowParkingInfo = false
     }
    
    
}
