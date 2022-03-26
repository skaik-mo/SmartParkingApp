//  Skaik_mo
//
//  AddParkingViewController.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 26/03/2022.
//

import UIKit
import GoogleMaps

class AddParkingViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var parkingNameText: UITextField!

    @IBOutlet weak var parkingImage: UIImageView!

    @IBOutlet weak var selectDate: SelectDateOrTime!
    @IBOutlet weak var selectTime: SelectDateOrTime!

    @IBOutlet weak var numberOfParking: NumberOfParking!

    @IBOutlet weak var hourButton: GreenButton!
    @IBOutlet weak var perdayButton: GreenButton!


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

extension AddParkingViewController {

    func setupView() {
        self.title = "Add new Parking"
        
        GoogleMapManager.initParkingLoction(parkingLocation: nil, mapView: mapView)
        
        self.parkingNameText._placeholderColor = .black
        
        self.selectDate.selectionType = .date
        self.selectDate.title.text = "Availability:"
        self.selectDate.title.textColor = .black
        self.selectDate.isHiddenIcons = true
        self.selectDate.fromImageView.isHidden = false
        self.selectDate.fromLabel.text = "Date From"


        self.selectTime.selectionType = .time
        self.selectTime.title.isHidden = true
        self.selectTime.isHiddenIcons = true
        self.selectTime.fromImageView.isHidden = false
        self.selectTime.fromLabel.text = "Time From"

        numberOfParking.typeParkingView = .grayWithBorder
        numberOfParking.button.isHidden = false
        numberOfParking.title.text = "Spots"

        self.hourButton.handleButton = {
            debugPrint("hourButton")
        }
        
        self.perdayButton.greenButton.backgroundColor = "F6F6F9"._hexColor
        self.perdayButton.greenButton.setTitleColor(.black, for: .normal)
        self.perdayButton.handleButton = {
            debugPrint("perdayButton")
        }
    }

    func localized() {

    }

    func setupData() {

    }

    func fetchData() {

    }

}

