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

    private var locationManager = CLLocationManager()
    private var coordinate: CLLocationCoordinate2D?

//    var placesClient: GMSPlacesClient!
    var handler: ((_ coordinate: CLLocationCoordinate2D?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._setTitleBackBarButton()
        AppDelegate.shared?.rootNavigationController?.setTransparentNavigation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.shared?.rootNavigationController?.setWhiteNavigation()
        self.handler?(self.coordinate)
    }
    
}

extension AddLocationViewController {

    func setupView() {
        self.mapView.delegate = self
        GoogleMapManager.currentLocation(mapView: mapView, coordinate: locationManager.location?.coordinate)

//        placesClient = GMSPlacesClient.shared()

    }

//    func find() {
//        let token = GMSAutocompleteSessionToken.init()
//
//        // Create a type filter.
//        let filter = GMSAutocompleteFilter()
//        filter.type = .establishment
////        filter.locationBias = GMSPlaceRectangularLocationOption.
//
//        placesClient?.findAutocompletePredictions(fromQuery: self.searchTextField._getText, filter: filter, sessionToken: token, callback: { (results, error) in
//            if let error = error {
//                print("Autocomplete error: \(error)")
//                return
//            }
//            if let results = results {
//                for result in results {
//                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
//                }
//            }
//        })
//    }

    func setupData() {

    }

    func fetchData() {

    }

}

extension AddLocationViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.mapView.clear()
        self.coordinate = position.target
        GoogleMapManager.currentLocation(mapView: mapView, coordinate: position.target, isMoveCamera: false)
    }

}
