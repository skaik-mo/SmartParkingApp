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
        GoogleMapManager.shared.currentLocation(mapView: mapView, icon: ic_currentMarker._toImage)
        GoogleMapManager.shared.parkings.forEach { parking in
            GoogleMapManager.shared.setParkingLoction(mapView: mapView, parking: parking)
        }
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
        auth = AuthManager.shared.getLocalAuth()
        setImage()
        setUpMap()
        showAlertExpiryTime()
    }

    private func setImage() {
        self.authImage.fetchImageWithActivityIndicator(auth?.urlImage, ic_placeholderPerson)
    }

    private func showAlertExpiryTime() {
        guard GoogleMapManager.shared.hasLocationPermission() else { return }
        let expiryTime = 15
        BookingManager.shared.isBookingTimeExpired(userID: self.auth?.id) { getExpiryTime in
            if let _getExpiryTime = getExpiryTime, (_getExpiryTime <= 0 && _getExpiryTime >= -expiryTime) {
                let vc: AlertViewController = AlertViewController._instantiateVC(storyboard: self._userStoryboard)
                vc.modalPresentationStyle = .custom
                vc.modalTransitionStyle = .crossDissolve
                vc._presentVC()
            }
        }
    }
}

extension HomeUserViewController: GMSMapViewDelegate {

    private func setUpMap(filter: FilterModel? = nil) {
        mapView.delegate = self
        GoogleMapManager.shared.initCurrentLocationsAndParkings(mapView: mapView, filter: filter)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let location = GoogleMapManager.shared.locationManager
        guard marker.position.latitude != location.location?.coordinate.latitude,
            marker.position.latitude != location.location?.coordinate.latitude else { return false }

        if let parking = GoogleMapManager.shared.parkings.first(where: { marker.position.latitude == $0.latitude && marker.position.longitude == $0.longitude && marker.title == $0.name }) {
            self.parkingInfo.setUpView(parking: parking)
            self.isShowParkingInfo = true
        }
        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.isShowParkingInfo = false
    }

}
