//  Skaik_mo
//
//  AddLocationViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 27/04/2022.
//

import UIKit
import GoogleMaps

class AddLocationViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: GMSMapView!

    private var coordinate: CLLocationCoordinate2D?

    var handler: ((_ coordinate: CLLocationCoordinate2D?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.shared?.rootNavigationController?.setWhiteNavigation()
        self.handler?(self.coordinate)
    }

}

// MARK: - ViewDidLoad
extension AddLocationViewController {

    private func setUpViewDidLoad() {
        self.mapView.delegate = self
        GoogleMapManager.shared.currentLocation(mapView: mapView)
    }

}

// MARK: - ViewWillAppear
extension AddLocationViewController {

    private func setUpViewWillAppear() {
        self._setTitleBackBarButton()
        AppDelegate.shared?.rootNavigationController?.setTransparentNavigation()
    }

}

extension AddLocationViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.coordinate = position.target
        self.mapView.clear()
        GoogleMapManager.shared.setMarker(name: CURRENT_LOCATION_TITLE, coordinate: coordinate)
    }

}
