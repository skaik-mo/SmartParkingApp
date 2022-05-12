//  Skaik_mo
//
//  HomeUserViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 12/03/2022.
//

import UIKit
import GoogleMaps

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isShowParkingInfo = false
        AppDelegate.shared?.rootNavigationController?.setTransparentNavigation()
        setImage()
        setUpMap()
        showAlertExpiryTime()
    }

    @IBAction func filtersAction(_ sender: Any) {
        self._presentTopToBottom()
        let vc: FiltersViewController = FiltersViewController._instantiateVC(storyboard: self._userStoryboard)
        vc.completionHandler = { filter in
            self.setUpMap(filter: filter)
        }
        vc._presentVC()

    }
    @IBAction func currentLocationAction(_ sender: Any) {
        GoogleMapManager.setLocations(locationManager: self.locationManager, mapView: self.mapView)
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
        switchComponents()
    }

    func localized() {

    }

    func showAlertExpiryTime() {
        let expiryTime = 15
        
        BookingManager.shared.isBookingTimeExpired(userID: self.auth?.id) { getExpiryTime in
            if let _getExpiryTime = getExpiryTime , (_getExpiryTime <= 0 && _getExpiryTime >= -expiryTime) {
                let vc: AlertViewController = AlertViewController._instantiateVC(storyboard: self._userStoryboard)
                vc._presentVC()
            }
        }
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

    func setUpMap(filter: FilterModel? = nil) {
        mapView.delegate = self
        debugPrint("distance: \(filter?.distance) || Date from \(filter?.fromDate) , to \(filter?.toDate) || Time from \(filter?.fromTime) , to \(filter?.toTime)")
        GoogleMapManager.initLoctionManager(locationManager: locationManager, mapView: mapView, filter: filter)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard marker.position.latitude != locationManager.location?.coordinate.latitude,
            marker.position.latitude != locationManager.location?.coordinate.latitude else { return false }

        GoogleMapManager.parkings.forEach { parking in
            if marker.position.latitude == parking.latitude, marker.position.longitude == parking.longitude, marker.title == parking.name {
                self.parkingInfo.setUpView(parking: parking, auth: self.auth)
            }
        }
        self.isShowParkingInfo = true
        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.isShowParkingInfo = false
    }


}
