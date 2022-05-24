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

    private var isShowParkingInfo = false {
        didSet {
            self.switchComponents()
        }
    }

    private var auth: AuthModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
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
        GoogleMapManager.setCurrentLocationsAndParkings(mapView: self.mapView)
    }

    @IBAction func profileAction(_ sender: Any) {
        let vc: ProfileViewController = ProfileViewController._instantiateVC(storyboard: self._accountStoryboard)
        vc._push()
    }

    @IBAction func notificationAction(_ sender: Any) {
        let vc: TableViewController = TableViewController._instantiateVC(storyboard: self._userStoryboard)
        vc.typeView = .Notifications
        vc._push()
    }
}

// MARK: - ViewDidLoad
extension HomeUserViewController {

    private func setUpViewDidLoad() {
        self.title = "Home"
        auth = AuthManager.shared.getLocalAuth()
        switchComponents()
    }

    private func switchComponents() {
        self.parkingInfo.isHidden = !self.isShowParkingInfo
        self.currentLocationButton.isHidden = self.isShowParkingInfo
    }

}

// MARK: - ViewWillAppear
extension HomeUserViewController {

    private func setUpViewWillAppear() {
        self.isShowParkingInfo = false
        AppDelegate.shared?.rootNavigationController?.setTransparentNavigation()
        setImage()
        setUpMap()
        showAlertExpiryTime()
    }
    
    private func setImage() {
        self.authImage.fetchImage(auth?.urlImage)
    }
    
    private func showAlertExpiryTime() {
        let expiryTime = 15
        BookingManager.shared.isBookingTimeExpired(userID: self.auth?.id) { getExpiryTime in
            if let _getExpiryTime = getExpiryTime, (_getExpiryTime <= 0 && _getExpiryTime >= -expiryTime) {
                let vc: AlertViewController = AlertViewController._instantiateVC(storyboard: self._userStoryboard)
                vc._presentVC()
            }
        }
    }
}

extension HomeUserViewController: GMSMapViewDelegate {

    private func setUpMap(filter: FilterModel? = nil) {
        mapView.delegate = self
        GoogleMapManager.initCurrentLocationsAndParkings(mapView: mapView, filter: filter)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard marker.position.latitude != locationManager.location?.coordinate.latitude,
            marker.position.latitude != locationManager.location?.coordinate.latitude else { return false }

        GoogleMapManager.parkings.forEach { parking in
            if marker.position.latitude == parking.latitude, marker.position.longitude == parking.longitude, marker.title == parking.name {
                self.parkingInfo.setUpView(parking: parking)
            }
        }
        self.isShowParkingInfo = true
        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.isShowParkingInfo = false
    }

}
