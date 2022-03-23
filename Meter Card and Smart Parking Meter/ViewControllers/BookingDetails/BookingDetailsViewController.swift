//  Skaik_mo
//
//  BookingDetailsViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 23/03/2022.
//

import UIKit
import GoogleMaps

class BookingDetailsViewController: UIViewController {

    @IBOutlet weak var parkingStatusLabel: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var ratingView: Rating!

    @IBOutlet weak var parkingImage: UIImageView!

    @IBOutlet weak var numberOfParking: NumberOfParking!


    @IBOutlet weak var selectDate: SelectDateOrTime!
    @IBOutlet weak var selectTime: SelectDateOrTime!
    
    @IBOutlet weak var greenButton: GreenButton!
    
    var parking: Parking?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localized()
        setupData()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._setTitleBackBarButton()
    }

}

extension BookingDetailsViewController {

    func setupView() {
        self.title = "Booking Details"
        
        GoogleMapManager.initParkingLoction(parkingLocation: parking, mapView: mapView)
        
        self.ratingView.setUpRating(parking: parking, space: 12)
        
        self.parking?.setParkingImage(parkingImage: self.parkingImage)
        
        numberOfParking.typeParkingView = .fill
        numberOfParking.title.text = "Spot"
        
        
        self.selectDate.selectionType = .date
        self.selectDate.title.text = "Date"
        self.selectDate.isHiddenIcons = true
    
        
        self.selectTime.selectionType = .time
        self.selectTime.title.text = "Time"
        self.selectTime.isHiddenIcons = true

      
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}


extension BookingDetailsViewController {

}

