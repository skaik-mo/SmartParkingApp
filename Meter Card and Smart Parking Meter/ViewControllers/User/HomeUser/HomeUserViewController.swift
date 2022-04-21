//  Skaik_mo
//
//  HomeUserViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 12/03/2022.
//

import UIKit
import GoogleMaps
import SDWebImage

class HomeUserViewController: UIViewController {

    @IBOutlet weak var authImage: UIImageView!

    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var currentLocationButton: UIButton!

    @IBOutlet weak var parkingInfo: ParkingInfo!

    var isShowParkingInfo = false {
        didSet {
            self.switchComponents()
        }
    }

    var locationManager = CLLocationManager()
    var auth: AuthModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared?.rootNavigationController?.setTransparentNavigation()
        setImage()
    }

    @IBAction func filtersAction(_ sender: Any) {
        self._presentTopToBottom()
        let vc: FiltersViewController = FiltersViewController._instantiateVC(storyboard: self._userStoryboard)
        vc._presentVC()

    }
    @IBAction func currentLocationAction(_ sender: Any) {
//        GoogleMapManager.currentLocation(mapView: mapView, locationManager: locationManager)
        GoogleMapManager.initLoctionManager(locationManager: locationManager, mapView: mapView)
    }

    @IBAction func profileAction(_ sender: Any) {
        let vc: ProfileViewController = ProfileViewController._instantiateVC(storyboard: self._authStoryboard)
        vc.auth = auth
        vc.backAuth = { auth in
            self.auth = auth
            self.setImage()
        }
        vc._push()
    }


}

extension HomeUserViewController {

    func setupView() {
        self.title = "Home"
        setUpMap()

        switchComponents()
    }

    func localized() {

    }

    func setupData() {

    }

    func setImage() {
        AuthManager.shared.setImage(authImage: self.authImage, urlImage: auth?.urlImage)
    }

    func switchComponents() {
        self.parkingInfo.isHidden = !self.isShowParkingInfo
        self.currentLocationButton.isHidden = self.isShowParkingInfo
    }


}

extension HomeUserViewController: GMSMapViewDelegate {

    func setUpMap() {
        mapView.delegate = self
        GoogleMapManager.initLoctionManager(locationManager: locationManager, mapView: mapView)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard marker.position.latitude != locationManager.location?.coordinate.latitude,
            marker.position.latitude != locationManager.location?.coordinate.latitude else { return false }

        GoogleMapManager.parkingLocations.forEach { parking in
            if marker.position.latitude == parking.latitude, marker.position.longitude == parking.longitude, marker.title == parking.name {
                self.parkingInfo.parking = parking
                self.parkingInfo.setUpView()
            }
        }
        self.isShowParkingInfo = true
        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.isShowParkingInfo = false
    }


}
